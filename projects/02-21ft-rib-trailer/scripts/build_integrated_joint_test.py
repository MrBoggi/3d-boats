#!/usr/bin/env python3
"""Pack the mandatory one-plate PLA test for integrated frame joints."""

import json
import tempfile
import zipfile
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
    target = builder.OUTPUT / "integrated_frame_joint_test.3mf"
    if not target.is_file():
        raise RuntimeError("Existing PLA test project is required as profile template")

    expanded = []
    for name, count in builder.PETG_QUANTITIES.items():
        part = builder.load_part(name)
        expanded.extend([part] * count)
    plates = builder.pack(expanded)
    if len(plates) != 1:
        raise RuntimeError(f"Integrated joint test unexpectedly needs {len(plates)} plates")
    generated = builder.make_project("petg", 1, plates[0], target)

    # build_plate_3mf intentionally enables supports for production plates.
    # These coupons are oriented to print without supports and use the proven
    # PolySmart PLA test profile instead.
    with zipfile.ZipFile(generated) as source:
        files = {name: source.read(name) for name in source.namelist()
                 if not name.endswith("/")}
    settings = json.loads(files["Metadata/project_settings.config"])
    settings.update({
        "enable_support": "0",
        "nozzle_temperature": ["215"],
        "hot_plate_temp": ["55"],
        "wall_loops": "4",
        "top_shell_layers": "5",
        "bottom_shell_layers": "5",
        "sparse_infill_density": "15%",
        "sparse_infill_pattern": "gyroid",
    })
    files["Metadata/project_settings.config"] = (
        json.dumps(settings, indent=4).encode() + b"\n")
    with tempfile.NamedTemporaryFile(suffix=".3mf", delete=False,
                                     dir=builder.OUTPUT) as temporary:
        temporary_path = Path(temporary.name)
    with zipfile.ZipFile(temporary_path, "w", zipfile.ZIP_DEFLATED) as archive:
        for name, data in files.items():
            archive.writestr(name, data)

    temporary_path.replace(target)
    generated.unlink()
    for extra in builder.OUTPUT.glob("trailer_*_plate_*.3mf"):
        extra.unlink()
    readme.write_bytes(readme_body)
