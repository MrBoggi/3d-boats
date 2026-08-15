#!/usr/bin/env python3
"""Build full-quantity, pre-arranged Bambu Studio 3MF plate projects.

The script reuses the already verified one-part 3MF projects as geometry and
profile templates.  Parts are packed as conservative axis-aligned rectangles;
90 degree rotation is allowed and a 6 mm keep-out is retained around objects.
"""

from __future__ import annotations

import copy
import json
import math
import re
import shutil
import subprocess
import tempfile
import uuid
import zipfile
from dataclasses import dataclass
from pathlib import Path
from xml.etree import ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "3mf"
OUTPUT = SOURCE / "plates"
BED = 256.0
EDGE = 6.0
GAP = 6.0

# Exact quantities used by assembled_trailer().  Purchased wheels and
# fasteners are deliberately not included.
PETG_QUANTITIES = {
    "drawbar_front": 1,
    "drawbar_rear": 1,
    "frame_rail_middle": 2,
    "frame_rail_rear": 2,
    "splice_plate": 4,
    "v_rail_joint_plate": 4,
    "crossmember": 2,
    "rear_accessory_crossmember": 1,
    "coupler_mount_adapter": 1,
    "bogie_arm": 2,
    "bogie_mount": 2,
    "wheel_hex_adapter": 4,
    "tandem_fender": 2,
    "fender_mount_bracket": 2,
    "keel_roller": 4,
    "keel_roller_bracket_front": 2,
    "keel_roller_bracket_mid_front": 2,
    "keel_roller_bracket_mid_rear": 2,
    "keel_roller_bracket_rear": 2,
    "side_support_receiver": 4,
    "side_support_post_front": 2,
    "side_support_post_rear": 2,
    "side_support_roller": 8,
    "side_roller_wobble_holder": 8,
    "side_double_roller_cradle": 4,
    "winch_tower_body": 1,
    "winch_drum": 1,
    "winch_crank": 1,
    "rear_light_housing": 2,
    "rear_light_lens": 2,
    "license_plate_holder": 1,
}
TPU_QUANTITIES = {"bow_stop": 1}

CORE = "http://schemas.microsoft.com/3dmanufacturing/core/2015/02"
PROD = "http://schemas.microsoft.com/3dmanufacturing/production/2015/06"
RELS = "http://schemas.openxmlformats.org/package/2006/relationships"
ET.register_namespace("", CORE)
ET.register_namespace("p", PROD)
ET.register_namespace("BambuStudio", "http://schemas.bambulab.com/package/2021")


@dataclass
class Part:
    name: str
    source: Path
    object_xml: bytes
    component_transform: list[float]
    linear: list[float]
    width: float
    depth: float
    z_shift: float


@dataclass
class Placement:
    part: Part
    x: float
    y: float
    rotated: bool
    instance: int


def matrix_values(text: str | None) -> list[float]:
    if not text:
        return [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]
    return [float(v) for v in text.split()]


def apply_linear(m: list[float], x: float, y: float, z: float):
    return (
        m[0] * x + m[3] * y + m[6] * z,
        m[1] * x + m[4] * y + m[7] * z,
        m[2] * x + m[5] * y + m[8] * z,
    )


def load_part(name: str) -> Part:
    source = SOURCE / f"{name}.3mf"
    with zipfile.ZipFile(source) as archive:
        top = ET.fromstring(archive.read("3D/3dmodel.model"))
        object_xml = archive.read("3D/Objects/object_1.model")
    component = top.find(f".//{{{CORE}}}component")
    item = top.find(f".//{{{CORE}}}build/{{{CORE}}}item")
    comp_m = matrix_values(component.get("transform") if component is not None else None)
    build_m = matrix_values(item.get("transform") if item is not None else None)
    linear = build_m[:9]

    obj = ET.fromstring(object_xml)
    points = []
    for vertex in obj.findall(f".//{{{CORE}}}vertex"):
        p = [float(vertex.get(axis, "0")) for axis in ("x", "y", "z")]
        p = apply_linear(comp_m, *p)
        p = (p[0] + comp_m[9], p[1] + comp_m[10], p[2] + comp_m[11])
        p = apply_linear(linear, *p)
        points.append(p)
    mins = [min(p[i] for p in points) for i in range(3)]
    maxs = [max(p[i] for p in points) for i in range(3)]
    return Part(name, source, object_xml, comp_m, linear,
                maxs[0] - mins[0], maxs[1] - mins[1], -mins[2])


def pack(parts: list[Part]) -> list[list[Placement]]:
    # MaxRects-style first-fit decreasing.  Rectangles include the desired gap.
    ordered = sorted(parts, key=lambda p: max(p.width, p.depth), reverse=True)
    plates: list[tuple[list[tuple[float, float, float, float]], list[Placement]]] = []
    counters: dict[str, int] = {}

    for part in ordered:
        counters[part.name] = counters.get(part.name, 0) + 1
        choices = [(part.width, part.depth, False), (part.depth, part.width, True)]
        best = None
        for plate_index, (free, _) in enumerate(plates):
            for free_index, (fx, fy, fw, fh) in enumerate(free):
                for w, h, rotated in choices:
                    rw, rh = w + GAP, h + GAP
                    if rw <= fw + 1e-6 and rh <= fh + 1e-6:
                        score = (min(fw - rw, fh - rh), max(fw - rw, fh - rh))
                        candidate = (score, plate_index, free_index, fx, fy,
                                     w, h, rw, rh, rotated)
                        if best is None or candidate[0] < best[0]:
                            best = candidate
        if best is None:
            usable = BED - 2 * EDGE
            plates.append(([(EDGE, EDGE, usable, usable)], []))
            plate_index = len(plates) - 1
            free_index = 0
            fx = fy = EDGE
            valid = [(w, h, r) for w, h, r in choices
                     if w + GAP <= usable + 1e-6 and h + GAP <= usable + 1e-6]
            if not valid:
                raise RuntimeError(f"{part.name} ({part.width:.1f} x {part.depth:.1f}) does not fit A1")
            w, h, rotated = min(valid, key=lambda item: item[0] * item[1])
            rw, rh = w + GAP, h + GAP
        else:
            _, plate_index, free_index, fx, fy, w, h, rw, rh, rotated = best

        free, placed = plates[plate_index]
        _, _, fw, fh = free.pop(free_index)
        # Guillotine split; add larger leftover first for deterministic packing.
        new_rects = []
        if fw - rw > 0.1:
            new_rects.append((fx + rw, fy, fw - rw, rh))
        if fh - rh > 0.1:
            new_rects.append((fx, fy + rh, fw, fh - rh))
        free.extend(sorted(new_rects, key=lambda r: r[2] * r[3], reverse=True))
        placed.append(Placement(part, fx + GAP / 2, fy + GAP / 2,
                                rotated, counters[part.name]))
    return [placements for _, placements in plates]


def format_transform(part: Part, placement: Placement) -> str:
    # Re-evaluate the transformed bbox, optionally with an additional +90° Z turn.
    with zipfile.ZipFile(part.source) as archive:
        obj = ET.fromstring(archive.read("3D/Objects/object_1.model"))
    linear = list(part.linear)
    if placement.rotated:
        # Row-vector convention used by 3MF: world = local * matrix.
        a = linear
        linear = [-a[1], a[0], a[2], -a[4], a[3], a[5],
                  -a[7], a[6], a[8]]
    points = []
    for vertex in obj.findall(f".//{{{CORE}}}vertex"):
        p = [float(vertex.get(axis, "0")) for axis in ("x", "y", "z")]
        p = apply_linear(part.component_transform, *p)
        p = (p[0] + part.component_transform[9],
             p[1] + part.component_transform[10],
             p[2] + part.component_transform[11])
        points.append(apply_linear(linear, *p))
    mins = [min(p[i] for p in points) for i in range(3)]
    tx = placement.x - mins[0]
    ty = placement.y - mins[1]
    tz = -mins[2]
    values = linear + [tx, ty, tz]
    return " ".join(f"{v:.9g}" for v in values)


def make_project(material: str, index: int, placements: list[Placement], template: Path):
    with zipfile.ZipFile(template) as archive:
        files = {name: archive.read(name) for name in archive.namelist()
                 if not name.endswith("/")}
    top = ET.fromstring(files["3D/3dmodel.model"])
    resources = top.find(f"{{{CORE}}}resources")
    build = top.find(f"{{{CORE}}}build")
    resources.clear()
    build.clear()
    build.set(f"{{{PROD}}}UUID", f"00000002-{str(uuid.uuid4())[9:]}")

    model_config = ET.fromstring(files["Metadata/model_settings.config"])
    for child in list(model_config):
        model_config.remove(child)
    plate_xml = ET.SubElement(model_config, "plate")
    for key, value in (("plater_id", "1"), ("plater_name", f"{material.upper()} plate {index:02d}"),
                       ("locked", "false"), ("filament_map_mode", "Auto For Flush"),
                       ("gcode_file", "")):
        ET.SubElement(plate_xml, "metadata", key=key, value=value)

    copied: dict[str, int] = {}
    instance_ids: dict[str, int] = {}
    identify = 1
    for placement in placements:
        part = placement.part
        if part.name not in copied:
            resource_id = 2 + len(copied)
            copied[part.name] = resource_id

            # Bake the source component transform into the vertices and embed
            # the mesh directly. Bambu then has no external object to resolve.
            embedded_model = ET.fromstring(part.object_xml)
            embedded_object = embedded_model.find(f".//{{{CORE}}}object")
            embedded_object.set("id", str(resource_id))
            embedded_object.set(f"{{{PROD}}}UUID",
                                f"00000001-{str(uuid.uuid4())[9:]}")
            for vertex in embedded_object.findall(f".//{{{CORE}}}vertex"):
                point = [float(vertex.get(axis, "0")) for axis in ("x", "y", "z")]
                point = apply_linear(part.component_transform, *point)
                point = (point[0] + part.component_transform[9],
                         point[1] + part.component_transform[10],
                         point[2] + part.component_transform[11])
                for axis, value in zip(("x", "y", "z"), point):
                    vertex.set(axis, f"{value:.9g}")
            resources.append(copy.deepcopy(embedded_object))

            with zipfile.ZipFile(part.source) as source_archive:
                source_config = ET.fromstring(
                    source_archive.read("Metadata/model_settings.config"))
            source_object = source_config.find("object")
            config_object = copy.deepcopy(source_object)
            config_object.set("id", str(resource_id))
            part_config = config_object.find("part")
            matrix = part_config.find("metadata[@key='matrix']")
            if matrix is not None:
                matrix.set("value", "1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1")
            for key in ("source_offset_x", "source_offset_y", "source_offset_z"):
                offset = part_config.find(f"metadata[@key='{key}']")
                if offset is not None:
                    offset.set("value", "0")
            model_config.append(config_object)
            instance_ids[part.name] = 0

        resource_id = copied[part.name]
        transform = format_transform(part, placement)
        ET.SubElement(build, f"{{{CORE}}}item", {
            "objectid": str(resource_id),
            f"{{{PROD}}}UUID": f"00000002-{str(uuid.uuid4())[9:]}",
            "transform": transform, "printable": "1"})
        instance_id = instance_ids[part.name]
        instance_ids[part.name] += 1
        instance = ET.SubElement(plate_xml, "model_instance")
        ET.SubElement(instance, "metadata", key="object_id", value=str(resource_id))
        ET.SubElement(instance, "metadata", key="instance_id", value=str(instance_id))
        ET.SubElement(instance, "metadata", key="identify_id", value=str(identify))
        identify += 1
    ET.SubElement(model_config, "assemble")

    settings = json.loads(files["Metadata/project_settings.config"])
    settings["printable_area"] = ["0x0", "256x0", "256x256", "0x256"]
    settings["bed_exclude_area"] = []
    files["Metadata/project_settings.config"] = json.dumps(settings, indent=4).encode() + b"\n"
    files["3D/3dmodel.model"] = ET.tostring(top, encoding="utf-8", xml_declaration=True)
    files["Metadata/model_settings.config"] = ET.tostring(
        model_config, encoding="utf-8", xml_declaration=True)

    for name in list(files):
        if name.startswith("3D/Objects/") or name == "3D/_rels/3dmodel.model.rels":
            del files[name]

    target = OUTPUT / f"trailer_{material}_plate_{index:02d}.3mf"
    with zipfile.ZipFile(target, "w", zipfile.ZIP_DEFLATED) as archive:
        for name, data in files.items():
            archive.writestr(name, data)
    validate_project(target, placements, len(copied))
    return target


def validate_project(path: Path, placements: list[Placement], object_count: int):
    """Fail generation on a malformed archive or a zero-size embedded mesh."""
    with zipfile.ZipFile(path) as archive:
        bad = archive.testzip()
        if bad:
            raise RuntimeError(f"Corrupt member in {path.name}: {bad}")
        top = ET.fromstring(archive.read("3D/3dmodel.model"))
        items = top.findall(f".//{{{CORE}}}build/{{{CORE}}}item")
        objects = top.findall(f".//{{{CORE}}}resources/{{{CORE}}}object")
        if len(items) != len(placements):
            raise RuntimeError(f"Wrong instance count in {path.name}")
        if len(objects) != object_count:
            raise RuntimeError(f"Wrong embedded object count in {path.name}")
        object_ids = {obj.get("id") for obj in objects}
        if any(item.get("objectid") not in object_ids for item in items):
            raise RuntimeError(f"Broken build reference in {path.name}")
        for obj in objects:
            vertices = obj.findall(f".//{{{CORE}}}vertex")
            triangles = obj.findall(f".//{{{CORE}}}triangle")
            if not vertices or not triangles:
                raise RuntimeError(f"Zero-size object in {path.name}")

def arrange_with_bambu(projects: list[tuple[Path, list[Placement]]]):
    """Use Bambu Studio's real clearance rules for final physical plates."""
    if shutil.which("flatpak-spawn"):
        command = ["flatpak-spawn", "--host", "flatpak", "run",
                   "com.bambulab.BambuStudio"]
    elif shutil.which("flatpak"):
        command = ["flatpak", "run", "com.bambulab.BambuStudio"]
    else:
        raise RuntimeError(
            "Bambu Studio Flatpak is required for collision-safe final arrangement")

    for path, _ in projects:
        arranged = path.with_name(f".{path.stem}_arranged.3mf")
        subprocess.run(command + [
            "--ensure-on-bed", "--arrange", "1", "--allow-rotations",
            "--export-3mf", str(arranged.resolve()), str(path.resolve())
        ], check=True)
        if not arranged.is_file() or arranged.stat().st_size == 0:
            raise RuntimeError(f"Bambu Studio did not create {arranged.name}")
        arranged.replace(path)


def physical_plate_count(path: Path) -> int:
    with zipfile.ZipFile(path) as archive:
        config = ET.fromstring(archive.read("Metadata/model_settings.config"))
    return len(config.findall("plate"))


def write_manifest(projects: list[tuple[Path, list[Placement]]]):
    total_physical = sum(physical_plate_count(path) for path, _ in projects)
    lines = ["# Ferdig arrangerte printplater", "",
             "A1, 256 × 256 mm. Antallene dekker én komplett henger.",
             f"Prosjektfilene inneholder totalt {total_physical} fysiske platefaner.", ""]
    for path, placements in projects:
        counts: dict[str, int] = {}
        for placement in placements:
            counts[placement.part.name] = counts.get(placement.part.name, 0) + 1
        lines += [f"## {path.name}", "",
                  f"Fysiske platefaner: {physical_plate_count(path)}", ""]
        lines += [f"- `{name}` × {count}" for name, count in sorted(counts.items())]
        lines.append("")
    (OUTPUT / "README.md").write_text("\n".join(lines), encoding="utf-8")


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for old in OUTPUT.glob("trailer_*_plate_*.3mf"):
        old.unlink()
    projects = []
    for material, quantities, template_name in (
            ("petg", PETG_QUANTITIES, "bogie_mount.3mf"),
            ("tpu", TPU_QUANTITIES, "bow_stop.3mf")):
        expanded = []
        for name, count in quantities.items():
            part = load_part(name)
            expanded.extend([part] * count)
        for index, placements in enumerate(pack(expanded), 1):
            target = make_project(material, index, placements,
                                  SOURCE / template_name)
            projects.append((target, placements))
            print(f"{target.name}: {len(placements)} objects")
    arrange_with_bambu(projects)
    write_manifest(projects)
    print(f"Created {len(projects)} collision-safe plate projects in {OUTPUT}")


if __name__ == "__main__":
    main()
