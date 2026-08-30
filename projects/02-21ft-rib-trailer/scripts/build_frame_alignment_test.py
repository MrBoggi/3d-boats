#!/usr/bin/env python3
"""Pack the full-scale, low-material PLA frame alignment test."""

import json
import os
import zipfile
from pathlib import Path

import build_plate_3mf as builder


PROJECT = Path(__file__).resolve().parents[1]
builder.SOURCE = PROJECT / "3mf" / "alignment_tests" / "parts"
builder.OUTPUT = PROJECT / "3mf" / "alignment_tests"
builder.PETG_QUANTITIES = {
    "alignment_drawbar_front": 1,
    "alignment_drawbar_rear": 1,
    "alignment_frame_rail_middle": 2,
    "alignment_frame_rail_rear": 2,
    "alignment_crossmember": 1,
    "alignment_crossmember_mid": 1,
    "alignment_rear_accessory_crossmember": 1,
}
builder.TPU_QUANTITIES = {}


def apply_pla_profile():
    """Use one consistent PolySmart PLA test profile on every source part."""
    template = builder.SOURCE / "alignment_frame_rail_middle.3mf"
    with zipfile.ZipFile(template) as archive:
        settings = json.loads(archive.read("Metadata/project_settings.config"))
    settings.update({
        "layer_height": "0.2",
        "wall_loops": "4",
        "top_shell_layers": "5",
        "bottom_shell_layers": "5",
        "sparse_infill_density": "15%",
        "sparse_infill_pattern": "gyroid",
        "enable_support": "0",
        "nozzle_temperature": ["215"],
        "nozzle_temperature_initial_layer": ["215"],
        "hot_plate_temp": ["55"],
        "hot_plate_temp_initial_layer": ["55"],
    })
    profile = (json.dumps(settings, indent=4) + "\n").encode()
    for path in builder.SOURCE.glob("*.3mf"):
        with zipfile.ZipFile(path) as source:
            files = {name: source.read(name) for name in source.namelist()
                     if not name.endswith("/")}
        files["Metadata/project_settings.config"] = profile
        temporary = path.with_suffix(".tmp")
        with zipfile.ZipFile(temporary, "w", zipfile.ZIP_DEFLATED) as target:
            for name, data in files.items():
                target.writestr(name, data)
        os.replace(temporary, path)


if __name__ == "__main__":
    apply_pla_profile()
    builder.main()
    for old in builder.OUTPUT.glob("frame_alignment_test_plate_*.3mf"):
        old.unlink()
    for project in builder.OUTPUT.glob("trailer_petg_plate_*.3mf"):
        project.rename(project.with_name(project.name.replace(
            "trailer_petg_plate_", "frame_alignment_test_plate_", 1)))
    manifest = builder.OUTPUT / "README.md"
    body = manifest.read_text(encoding="utf-8").replace(
        "trailer_petg_plate_", "frame_alignment_test_plate_")
    intro = """# Fullskala ramme-/alignment-test i PLA

Print alle platene og skru sammen hele rammen før produksjonsdelene printes i PETG. Delene bruker eksakt produksjonskontur og hullplassering, full 18 mm tykkelse rundt skjøter og hull, og en 2,4 mm web mellom kontrollpunktene. Testen kontrollerer geometri og monteringslogikk, ikke styrke.

Profil: Bambu Lab A1, 0,4 mm dyse, 0,20 mm lag, PolySmart PLA Phantom Black, 215 °C dyse, 55 °C plate, fire vegger, fem topp-/bunnlag og 15 % gyroid. Kontroller alltid valgt filament og byggeplate før utskrift.

"""
    manifest.write_text(intro + body.replace(
        "# Ferdig arrangerte printplater\n\n", "## Plateinnhold\n\n", 1),
        encoding="utf-8")
