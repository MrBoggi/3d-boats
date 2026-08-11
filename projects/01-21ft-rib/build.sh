#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" != "--approved" ]]; then
    echo "Refusing STL export: review src/assembly.scad first." >&2
    echo "After visual approval, run: ./build.sh --approved" >&2
    exit 2
fi

if ! command -v openscad >/dev/null 2>&1; then
    echo "Error: openscad was not found in PATH." >&2
    exit 1
fi

mkdir -p stl_export

parts=(
    hull_stage5_bow hull_stage5_mid hull_stage5_stern
    cockpit_floor_fixed floor_battery_lid floor_aft_lid
    console_stage1 console_oled_retainer windshield_frame
    helm_bench_cushion helm_bench_frame_port helm_bench_frame_starboard
    helm_bench_cross_braces helm_bench_side_rails
    aft_bench_servo_cover aft_bench_cushion aft_bench_backrest aft_bench_seat_support
    bow_locker_base bow_cushion bow_rail_port bow_rail_starboard bow_anchor_roller
    outboard_xl_adapter
    ladder
)

for part in "${parts[@]}"; do
    echo "Exporting ${part}.stl"
    openscad \
        -o "stl_export/${part}.stl" \
        -D "selected_part=\"${part}\"" \
        src/assembly.scad
done

echo "Done. STL files are in stl_export/."
