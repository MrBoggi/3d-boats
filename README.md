# 3dBoats

A collection of parametric OpenSCAD boat projects intended for 3D printing.

## Repository layout

```text
3dBoats/
├── projects/   # Individual printable boat projects
├── shared/     # Reusable OpenSCAD modules and component wrappers
└── scripts/    # Repository-wide build helpers (when added)
```

Each directory under `projects/` contains its own source files, build script,
and project-specific documentation.

## Projects

- [`projects/01-21ft-rib`](projects/01-21ft-rib/) — 1:10 scale, 660 mm RC RIB
  with a three-part V-hull, removable interior, and steerable outboard motor.
