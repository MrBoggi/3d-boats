#!/usr/bin/env python3
"""Build only parts still required after the documented trial prints."""

from pathlib import Path
import build_plate_3mf as builder

builder.OUTPUT = builder.SOURCE / "remaining_after_trial"
builder.PETG_QUANTITIES = {
    # Reprint: geometry changed after the first physical joint trial.
    "drawbar_front": 1,
    "drawbar_rear": 1,
    "frame_rail_middle": 2,
    "frame_rail_rear": 2,
    "coupler_mount_adapter": 1,
    "crossmember_mid": 1,
    "rear_accessory_crossmember": 1,
    "side_double_roller_cradle": 4,
    "side_roller_wobble_holder": 8,

    # Not printed: old PETG project 03 physical tab 2.
    "fender_mount_bracket": 1,
    "keel_roller_bracket_mid_rear": 2,
    "keel_roller_bracket_rear": 2,
    "license_plate_holder": 1,
    "rear_light_lens": 2,
    "side_support_post_front": 2,
    "side_support_post_rear": 2,
    "side_support_roller": 8,

    # Explicitly reported missing from the physical print.
    "winch_tower_body": 1,
}
builder.TPU_QUANTITIES = {"bow_stop": 1}

if __name__ == "__main__":
    builder.OUTPUT.mkdir(parents=True, exist_ok=True)
    for old_project in builder.OUTPUT.glob("remaining_*_plate_*.3mf"):
        old_project.unlink()
    builder.main()
    for project in builder.OUTPUT.glob("trailer_*_plate_*.3mf"):
        project.rename(project.with_name(project.name.replace("trailer_", "remaining_", 1)))
    manifest = builder.OUTPUT / "README.md"
    body = manifest.read_text(encoding="utf-8").replace(
        "trailer_petg_", "remaining_petg_").replace(
        "trailer_tpu_", "remaining_tpu_")
    note = """# Restutskrift etter prøveprint

Forutsetning: Begge faner i gamle PETG-prosjekt 01 og 02 er printet. Av gamle PETG-prosjekt 03 er bare fysisk fane 1 printet, men `winch_tower_body` mangler fysisk. TPU-baugstoppen regnes som ikke printet.

Settet inneholder uprintede deler og alle tidligere printede deler som ble foreldet av skjøte-/sidestøtteredesignet. Det er ikke en komplett henger nummer to.

"""
    manifest.write_text(note + body.replace("# Ferdig arrangerte printplater\n\n", "## Plateinnhold\n\n", 1), encoding="utf-8")
