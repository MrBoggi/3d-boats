#!/usr/bin/env python3
"""Build a low-waste, full-scale mechanical interface verification plate."""

import os
import zipfile
from pathlib import Path
import build_plate_3mf as builder

PROJECT = Path(__file__).resolve().parents[1]
builder.SOURCE = PROJECT / "3mf" / "fit_tests" / "parts"
builder.OUTPUT = PROJECT / "3mf" / "fit_tests"
builder.PETG_QUANTITIES = {
    "fit_v_front": 1,
    "fit_v_rear": 1,
    "fit_coupler_frame": 1,
    "coupler_mount_adapter": 1,
    "fit_splice_front": 1,
    "fit_splice_rear": 1,
    "splice_plate": 1,
    "fit_mid_rail": 1,
    "fit_mid_crossmember": 1,
    "crossmember_joint_plate_mid": 2,
    "fit_rear_rail": 1,
    "fit_rear_crossmember": 1,
    "crossmember_joint_plate_rear": 2,
    "fit_side_post_head": 1,
    "side_double_roller_cradle": 1,
    "side_roller_wobble_holder": 1,
}
builder.TPU_QUANTITIES = {}


def apply_petg_profile():
    template = PROJECT / "3mf" / "bogie_mount.3mf"
    with zipfile.ZipFile(template) as archive:
        profile = archive.read("Metadata/project_settings.config")
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
    apply_petg_profile()
    builder.main()
    for old in builder.OUTPUT.glob("fit_test_plate_*.3mf"):
        old.unlink()
    for project in builder.OUTPUT.glob("trailer_petg_plate_*.3mf"):
        project.rename(project.with_name(project.name.replace(
            "trailer_petg_plate_", "fit_test_plate_", 1)))
    manifest = builder.OUTPUT / "README.md"
    body = manifest.read_text(encoding="utf-8").replace(
        "trailer_petg_plate_", "fit_test_plate_")
    intro = """# Skjøte- og koblingstest

Print og godkjenn denne pakken før `remaining_after_trial` brukes. Kupongene er fullskala utsnitt av produksjonsgeometrien; hull, anleggsflater og klaringer er identiske. Bruk faktiske M3-skruer, skiver og muttere under kontrollen.

Godkjenn: fri innføring uten tvang, ingen synlig vridning, gjennomgående hull som flukter, plater som ligger plant, og fri vipping i begge siderulleledd.

"""
    manifest.write_text(intro + body.replace(
        "# Ferdig arrangerte printplater\n\n", "## Plateinnhold\n\n", 1), encoding="utf-8")
