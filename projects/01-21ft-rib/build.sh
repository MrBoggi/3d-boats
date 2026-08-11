#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" != "--approved" ]]; then
    echo "Refusing export: review scad/assembly.scad first." >&2
    echo "After visual approval, run: ./build.sh --approved" >&2
    exit 2
fi

if command -v openscad >/dev/null 2>&1; then
    openscad_cmd=(openscad)
elif command -v flatpak-spawn >/dev/null 2>&1 \
        && flatpak-spawn --host sh -lc "command -v openscad" >/dev/null 2>&1; then
    openscad_cmd=(flatpak-spawn --host openscad)
else
    echo "Error: openscad was not found locally or on the Flatpak host." >&2
    exit 1
fi

mkdir -p stl png

parts=(
    hull_bow hull_mid hull_stern
    cockpit_floor_fixed floor_battery_lid floor_aft_lid
    console console_oled_retainer windshield_frame
    helm_bench_cushion helm_bench_frame_port helm_bench_frame_starboard
    helm_bench_cross_braces helm_bench_side_rails
    aft_bench_servo_cover aft_bench_cushion aft_bench_backrest aft_bench_seat_support
    bow_locker_base bow_cushion bow_rail_port bow_rail_starboard bow_anchor_roller
    outboard_xl_adapter
    ladder
)

for part in "${parts[@]}"; do
    echo "Exporting ${part}.stl"
    "${openscad_cmd[@]}" \
        -o "stl/${part}.stl" \
        -D "selected_part=\"${part}\"" \
        scad/assembly.scad
done

echo "Rendering assembly PNG files"
"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1600,1000 \
    --camera=330,0,45,65,0,25,900 \
    -o png/assembly_isometric.png scad/assembly.scad
"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1600,1000 \
    --camera=330,0,45,0,0,0,900 \
    -o png/assembly_top.png scad/assembly.scad
"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1600,1000 \
    --camera=330,0,45,90,0,0,900 \
    -o png/assembly_side.png scad/assembly.scad
"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1600,1000 \
    --camera=330,0,45,65,0,25,900 \
    -o png/assembly_with_motor.png scad/assembly_with_motor.scad

echo "Done. STL files are in stl/ and PNG files are in png/."
