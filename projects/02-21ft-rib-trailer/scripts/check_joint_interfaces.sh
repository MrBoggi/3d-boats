#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if command -v openscad >/dev/null 2>&1; then
    scad=(openscad)
elif command -v flatpak-spawn >/dev/null 2>&1; then
    scad=(flatpak-spawn --host openscad)
else
    echo "OpenSCAD not found" >&2; exit 1
fi
parts=(
 drawbar_front drawbar_rear frame_rail_middle frame_rail_rear
 crossmember crossmember_mid rear_accessory_crossmember coupler_mount_adapter
 bogie_arm bogie_mount wheel_hex_adapter tandem_fender fender_mount_bracket
 keel_roller keel_roller_bracket_front keel_roller_bracket_mid_front
 keel_roller_bracket_mid_rear keel_roller_bracket_rear side_support_receiver
 side_support_post_front side_support_post_rear side_support_roller
 side_roller_wobble_holder side_double_roller_cradle winch_tower_body
 winch_drum winch_crank bow_stop rear_light_housing rear_light_lens
 license_plate_holder
)
empty_checks=(drawbar_joint_collision coupler_drawbar_collision
 crossmember_frame_collision side_support_pivot_collision
 side_wobble_pivot_collision bogie_fender_collision bow_stop_fork_collision
 winch_strap_stop_collision integrated_front_joint_collision
 integrated_mid_joint_collision integrated_rear_joint_collision
 integrated_rail_splice_collision)
tmp=".joint-check.$$"
mkdir -p "$tmp"
trap 'rm -rf -- "$tmp"' EXIT
for part in "${parts[@]}"; do
    log="$tmp/$part.log"
    "${scad[@]}" -o "$tmp/$part.stl" -D "selected_part=\"$part\"" scad/assembly.scad >"$log" 2>&1
    grep -q "Simple: *yes" "$log" || { cat "$log"; echo "FAIL: $part is not manifold" >&2; exit 1; }
    test -s "$tmp/$part.stl" || { echo "FAIL: $part is empty" >&2; exit 1; }
done
for check in "${empty_checks[@]}"; do
    log="$tmp/$check.log"
    "${scad[@]}" -o "$tmp/$check.stl" -D "selected_part=\"$check\"" scad/assembly.scad >"$log" 2>&1 || true
    grep -q "Current top level object is empty" "$log" || { cat "$log"; echo "FAIL: collision in $check" >&2; exit 1; }
done
echo "PASS: ${#parts[@]} printable parts are non-empty/manifold; ${#empty_checks[@]} interface checks are collision-free."
