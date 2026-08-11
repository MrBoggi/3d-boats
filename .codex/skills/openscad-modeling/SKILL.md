---
name: openscad-modeling
description: Create, modify, organize, and verify parametric OpenSCAD models and printable multipart assemblies. Use for .scad projects, STL export workflows, print-bed segmentation, mechanical clearances, fasteners, removable parts, or repository structure for 3D-printable designs.
---

# OpenSCAD Modeling

Build maintainable, parametric, printable models that follow the repository's existing conventions.

## Workflow

1. Inspect `AGENTS.md`, the repository layout, nearby projects, build scripts, and uncommitted changes. Preserve unrelated work.
2. Convert requirements into named parameters: envelope, wall thickness, clearances, hardware, print volume, and part selection.
3. Represent purchased hardware with simple clearance envelopes before shaping surrounding parts. Keep these envelopes visible in a debug assembly mode.
4. Separate structural, serviceable, moving, fragile, and cosmetic parts according to assembly and print orientation.
5. Reuse the repository's layout. If none exists, use:

   ```text
   projects/<project>/
   ├── README.md
   ├── build.sh
   └── src/
       ├── config.scad
       ├── hardware.scad
       ├── <part>.scad
       └── assembly.scad
   ```

6. Put dimensions and tolerances in `config.scad`. Keep modules in part files and selectable output in `assembly.scad`. Avoid unexplained literals.
7. Design interfaces explicitly: lead-ins, glue gaps, screw access, insert pockets, end stops, tool clearance, cable paths, and water seals where applicable.
8. Make fragile projections and support-heavy details separate parts. Place watertight joints away from shafts, bearings, and highly loaded mounts.
9. Add a build target for every printable part plus an assembly preview. Keep generated STL files out of source directories.
10. Render every target with the OpenSCAD CLI when available. Treat syntax errors, non-manifold geometry, empty output, and build-volume overflow as failures. Report unavailable checks clearly.

## OpenSCAD rules

- Use millimetres, a documented coordinate system, and descriptive `snake_case` names.
- Prefer modules and functions over copied geometry.
- Use `$fn` through quality parameters; keep preview inexpensive and export smooth.
- Use small boolean overlap tolerances to avoid coincident faces.
- Keep printable parts manifold and independently renderable.
- Use `assert()` for invalid configurations and critical dimensional limits.
- Do not model threads when a hole, insert, nut trap, or real fastener is more reliable.
- Orient exports deliberately; document any part that must be reoriented in the slicer.

## Documentation contract

Update the project README with overall dimensions, scale, printer/build-volume target, part list, print orientation, material, hardware, component maximum envelopes, example component links, assembly order, sealing, and verification status. Mark components as `required`, `example`, or `tested`; never imply an example part has been physically verified.

## Completion check

Confirm that source layout matches the repository, every output is selectable and renderable, mating parts share parameters, purchased components fit their reserved envelopes, loose parts are actually separate, all exports fit the target printer, and README instructions match the model.
