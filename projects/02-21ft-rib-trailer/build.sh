#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" != "--approved" ]]; then
    echo "Refusing export: inspect scad/assembly.scad first." >&2
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
    frame_rail_middle frame_rail_rear splice_plate v_rail_joint_plate
    crossmember_joint_plate_mid crossmember_joint_plate_rear
    coupler_mount_adapter crossmember crossmember_mid rear_accessory_crossmember drawbar_front drawbar_rear bogie_arm bogie_mount wheel_hex_adapter tandem_fender fender_mount_bracket
    keel_roller keel_roller_bracket_front keel_roller_bracket_mid_front
    keel_roller_bracket_mid_rear keel_roller_bracket_rear
    side_support_receiver side_support_post_front side_support_post_rear
    side_support_roller side_roller_wobble_holder side_double_roller_cradle winch_tower_body winch_drum winch_crank bow_stop
    rear_light_housing rear_light_lens license_plate_holder
)

for part in "${parts[@]}"; do
    echo "Exporting ${part}.stl"
    "${openscad_cmd[@]}" -o "stl/${part}.stl" \
        -D "selected_part=\"${part}\"" -D 'show_boat=false' \
        scad/assembly.scad
done

"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1600,1000 \
    -D 'show_keel_contact_debug=true' \
    -o "png/assembly_keel_contact.png" scad/assembly.scad

"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1600,1000 \
    -D 'show_side_contact_debug=true' \
    -o "png/assembly_side_contact.png" scad/assembly.scad

"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1400,900 \
    --camera="470,130,50,70,0,25,230" \
    -D 'selected_part="bogie_travel_review"' \
    -o "png/review_bogie_travel.png" scad/assembly.scad

"${openscad_cmd[@]}" --preview --projection=p --imgsize=1400,1000 \
    --camera="487,-145,52,68,0,32,190" \
    -D 'show_boat=false' -D 'show_road=false' -D 'show_hardware=true' \
    -o "png/review_service_bogie.png" scad/assembly.scad

"${openscad_cmd[@]}" --preview --projection=p --imgsize=1400,1000 \
    --camera="487,120,50,72,0,205,155" \
    -D 'show_boat=false' -D 'show_road=false' -D 'show_hardware=true' \
    -o "png/review_service_bogie_inner.png" scad/assembly.scad

"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1200,900 \
    --camera="24,-45,108,72,0,25,115" \
    -D 'selected_part="bow_stop_pivot_review"' \
    -o "png/review_bow_stop_pivot.png" scad/assembly.scad

"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1400,900 \
    --camera="36,-55,115,72,0,25,150" \
    -D 'show_hardware=true' \
    -o "png/review_winch_strap.png" scad/assembly.scad

"${openscad_cmd[@]}" --preview --autocenter --viewall \
    --projection=p --imgsize=1400,900 \
    --camera="625,-70,55,72,0,25,230" \
    -o "png/review_motor_clearance.png" scad/assembly.scad

for view in isometric top side; do
    case "$view" in
        isometric) camera="260,0,55,65,0,25,1050" ;;
        top) camera="260,0,55,0,0,0,1050" ;;
        side) camera="260,0,55,90,0,0,1050" ;;
    esac
    "${openscad_cmd[@]}" --preview --autocenter --viewall \
        --projection=p --imgsize=1600,1000 --camera="$camera" \
        -o "png/assembly_${view}.png" scad/assembly.scad
done

echo "Done. STL files are in stl/ and PNG files are in png/."
