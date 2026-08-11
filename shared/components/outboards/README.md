# Shared outboard references

## Printables 1191848 — RC Outboard Motor 1/10

Reusable, unmodified third-party reference for boat projects.

- Creator: NoMatter
- Source: https://www.printables.com/model/1191848-rc-outboard-motor-110
- Reported license: CC BY-NC-ND
- Motor: water-cooled 2948 brushless motor
- Transmission: 0.5 module, 12-tooth, 3 mm bevel gears
- Bearings: 603 (3 × 9 × 3 mm)

The original files are not stored in Git. Download and extract them to:

```text
vendor/printables-1191848/
└── rc-outboard-motor-110-model_files/
    ├── cover_02.stl
    ├── lowerbody_02.stl
    └── ...
```

Do not edit, scale, rename, or redistribute the source STLs. Project-specific
transom plates, adapters, servo links, and placement transforms belong in each
boat project.

The wrapper `printables_1191848.scad` imports the original parts at their
native scale and shared CAD coordinates. It also provides a dependency-free
clearance envelope for projects that do not have the vendor files installed.


## Verified reference datums

The native STL assembly has been recentered and mapped to boat coordinates:

- Boat X: motor forward direction
- Boat Y: starboard
- Boat Z: up
- Required orientation from native STL: rotate -90 degrees around Z
- Reference steering axis: X/Y = 0/0
- Propeller shaft level: Z = -55 mm
- Anticavitation plate reference: Z = -28 mm
