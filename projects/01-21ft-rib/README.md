# 21 ft RIB — 1:10 RC model

Parametric 660 × 252 mm RIB for a Bambu Lab A1. The approved design uses a three-section V-hull, integrated pontoons, a flat removable cockpit floor, removable interior modules, and a steerable 1:10 outboard.

## Status

The hull form, floor, helm console, helm bench, aft bench, bow seat and rails, transom interface, and XL outboard adapter are visually approved and design-locked. OpenSCAD compilation is checked before release. Production STL export, slicer review, physical fit, flotation, sealing, and water testing remain required.

## Main dimensions

| Item | Value |
|---|---:|
| Scale | 1:10 |
| Full-size class | 21 ft / approximately 6.6 m RIB |
| Model length | 660 mm |
| Maximum beam | 252 mm |
| Hull sections | 220 / 210 / 230 mm |
| Hull wall | 2.8 mm |
| Nominal pontoon diameter | 54 mm |
| Target printer | Bambu Lab A1, 256 × 256 × 256 mm |

The beam leaves only 4 mm total build-plate margin. Verify orientation and disable any brim that exceeds the plate before slicing.

## Selected hardware

| Component | Design reference | Product size | Reserved CAD envelope |
|---|---|---:|---:|
| Outboard | [NoMatter RC Outboard Motor 1/10](https://www.printables.com/model/1191848-rc-outboard-motor-110), Mount 0 | Vendor STL assembly | Vendor geometry |
| Motor | Water-cooled 2948 brushless motor required by vendor design | Confirm before purchase | Vendor cavity |
| Cooling jacket | [Surpass Hobby 29S / C30507](https://integy.shop/products/rc-boats-parts-c30507) | 29 mm motor class | Vendor cavity |
| ESC | [Hobbywing SeaKing 60A V3.1](https://www.hobbywing.com/en/products/seaking-v3-series75.html) | 60.5 × 38.5 × 25.6 mm | 80 × 50 × 35 mm |
| Steering servo | [Savöx SW-0250MG+](https://www.teamsavox.com/product/sw-0250mgp/) | 29.5 × 14 × 32.5 mm body, 40 mm flange | 42 × 22 × 38 mm |
| Battery | [Gens ace G-Tech 3S 2200 mAh 25C](https://www.genstattu.com/gens-ace-2200mah-3s-25c-11-1v-g-tech-lipo-battery-pack-with-deans-plug/) | 106 × 34 × 22 mm, 166 g | 150 × 50 × 35 mm |
| Console display | [AliExpress OLED module 1005012699312062](https://www.aliexpress.com/item/1005012699312062.html) | PCB 27.8 × 27.3 mm; active area 21.74 × 11.2 mm | 22.5 × 12 mm window |
| Receiver | Minimum two channels; not selected | — | 55 × 35 × 25 mm |
| Optional UBEC | 5–6 V, at least 5 A | — | 45 × 25 × 15 mm |

The console display retainer uses M1.6 thread-forming screws. The helm bench, aft service cover, and servo mounting are prepared for heat-set inserts; [M2 × 3 mm inserts](https://cnckitchenus.store/products/heat-set-insert-m2-x-3-100-pieces) are the current reference. Confirm every purchased component with calipers before committing to final prints.

## Outboard and XL adapter

The unmodified vendor files belong in `vendor/printables-1191848/` and are intentionally ignored by Git. Attribution and reusable import logic live in `shared/components/outboards/`.

The locked Mount 0 interface uses four holes measured from the vendor STL: 32.69 × 22.31 mm spacing. The project adapter has 3.6 mm M3 clearances, a 16 mm centre clearance, and a reinforced transom interface.

The vendor lower unit is too short for the scaled XL transom. The separate printable `outboard_xl_adapter` adds 28.4085 mm without modifying vendor geometry. It follows the measured upper and lower mating contours, carries four 3.4 mm bolt passages with continuous bosses, and reserves a 4 mm passage for the longer 3 mm drive shaft. Seal both faces with a thin marine sealant gasket and determine final bolt length during physical trial assembly.

## Printable parts

`build.sh` exports only current production parts:

- Hull: bow, mid, and stern sections with alignment keys and optional M3 clamping holes.
- Floor: fixed sole, battery hatch, and aft service hatch.
- Console: shell, OLED retainer, and separate windshield hoop.
- Helm bench: cushion, port/starboard frames, cross braces, and side rails.
- Aft bench: servo cover, cushion, backrest, and seat support.
- Bow: locker base, cushion, port/starboard rails, and anchor roller.
- Propulsion: XL leg adapter. The vendor outboard remains an external dependency.
- Accessory: removable ladder.

The old internal motor, shaft support, and fixed-shaft drivetrain files remain as historical design references in `src/`, but are not imported by the production assembly or exported by `build.sh`.

## Source and previews

- `src/assembly.scad`: production assembly and export selector.
- `src/assembly_with_motor.scad`: complete visual assembly including vendor outboard.
- `src/config.scad`: dimensions, component envelopes, tolerances, and locked datums.
- `src/hull_stage5_joints_preview.scad`: hull split/joint review.
- `src/floor_hull_integration_preview.scad`: floor and hull integration.
- `src/outboard_xl_extension_preview.scad`: motor/adapter interface review.
- Files ending in `_preview.scad`, `_structure_preview.scad`, `_check.scad`, or `_audit_preview.scad` are diagnostic views and are not production exports.

Generated PNG previews stay in `preview/` and generated meshes in `stl_export/`; both are ignored by Git.

## Build

Open and inspect the complete model first:

```sh
openscad src/assembly_with_motor.scad
```

Export all approved project-owned parts:

```sh
./build.sh --approved
```

Individual parts can be exported through `src/assembly.scad`, for example:

```sh
openscad -o outboard_xl_adapter.stl \
  -D "selected_part=\"outboard_xl_adapter\"" \
  src/assembly.scad
```

## Recommended print and assembly sequence

1. Print small interface samples for hull joints, heat-set inserts, servo, OLED, Mount 0, and XL adapter.
2. Dry-fit the vendor outboard, shaft, cooling hose, steering linkage, and electronics.
3. Print the three hull sections in PETG, ASA, or another water-resistant material. Use at least four perimeters and verify the 252 mm bed fit in Bambu Studio.
4. Bond hull joints with marine epoxy. Alignment keys position the sections; the M3 holes may clamp the joint while curing and provide mechanical redundancy.
5. Seal internal seams, insert pockets, and fastener penetrations. Leak-test the empty hull before installing electronics.
6. Install the flat floor and removable hatches, then console, benches, rails, servo, electronics, and outboard.
7. Check steering travel and hose/cable clearance through the full motor arc.
8. Perform bathtub flotation and trim tests before low-power water trials.

## Verification checklist

- [x] Approved geometry represented in the production assembly.
- [x] Hull split fits the nominal Bambu Lab A1 build volume.
- [x] Production export list excludes the abandoned internal drivetrain.
- [x] XL adapter has passed isolated CGAL manifold rendering (`Simple: yes`).
- [ ] Full STL batch exported after this cleanup.
- [ ] Every STL sliced and checked in Bambu Studio.
- [ ] Purchased components measured and physically test-fitted.
- [ ] Hull sealed and leak-tested.
- [ ] Static flotation, trim, steering, and powered water tests completed.

## Licensing

Project-authored files follow the repository license when one is added. Vendor outboard files are not redistributed; follow the license and attribution terms on the linked Printables page.
