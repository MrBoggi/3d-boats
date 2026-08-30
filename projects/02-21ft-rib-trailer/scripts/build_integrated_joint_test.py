#!/usr/bin/env python3
"""Pack the mandatory one-plate PLA test for integrated frame joints."""

from pathlib import Path

import build_plate_3mf as builder


PROJECT = Path(__file__).resolve().parents[1]
builder.SOURCE = PROJECT / "3mf" / "integrated_joint_tests" / "parts"
builder.OUTPUT = PROJECT / "3mf" / "integrated_joint_tests"
builder.PETG_QUANTITIES = {
    "fit_v_front": 1,
    "fit_v_rear": 1,
    "fit_front_v": 1,
    "fit_front_rail": 1,
    "fit_front_crossmember": 1,
    "fit_splice_front": 1,
    "fit_splice_rear": 1,
    "fit_mid_rail": 1,
    "fit_mid_crossmember": 1,
    "fit_rear_rail": 1,
    "fit_rear_crossmember": 1,
}
builder.TPU_QUANTITIES = {}


if __name__ == "__main__":
    readme = builder.OUTPUT / "README.md"
    readme_body = readme.read_bytes()
    builder.main()
    generated = builder.OUTPUT / "trailer_petg_plate_01.3mf"
    target = builder.OUTPUT / "integrated_frame_joint_test.3mf"
    if target.exists():
        target.unlink()
    generated.rename(target)
    for extra in builder.OUTPUT.glob("trailer_*_plate_*.3mf"):
        extra.unlink()
    readme.write_bytes(readme_body)
