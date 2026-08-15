include <config.scad>
use <frame.scad>
use <bogie.scad>
use <supports.scad>
use <winch.scad>
use <hardware.scad>
use <boat_reference.scad>
use <rear_accessories.scad>
use <fenders.scad>
use <coupler.scad>
use <environment.scad>

module assembled_trailer() {
    if (show_road)
        road_reference();

    color([0.55, 0.57, 0.60])
        assembled_frame();
    coupler_assembly();
    for (side = [-1, 1])
        bogie_assembly(side);
    for (side = [-1, 1])
        fender_assembly(side);
    supports_assembly();
    color([0.62, 0.64, 0.67])
        winch_tower();
    rear_accessories_assembly();

    if (show_hardware)
        trailer_hardware_envelopes();
    if (show_boat)
        boat_reference();
    if (show_boat && show_keel_contact_debug)
        boat_keel_contact_slices();
    if (show_boat && show_side_contact_debug)
        boat_side_contact_slices();
}

if (selected_part == "assembly")
    assembled_trailer();
else if (selected_part == "coupler_mount_adapter")
    coupler_mount_adapter();
else if (selected_part == "coupler_hardware_reference")
    purchased_coupler_envelope();
else if (selected_part == "drawbar_front")
    translate([-v_apex_x, 0, -frame_bottom_z]) drawbar_front();
else if (selected_part == "drawbar_rear")
    translate([-v_split_x + v_joint_overlap, 0, -frame_bottom_z])
        drawbar_rear();
else if (selected_part == "frame_rail_middle")
    rail_segment_export(1);
else if (selected_part == "frame_rail_rear")
    rail_segment_export(2);
else if (selected_part == "splice_plate")
    splice_plate();
else if (selected_part == "v_rail_joint_plate")
    v_rail_joint_plate_export();
else if (selected_part == "crossmember")
    crossmember_export(0);
else if (selected_part == "rear_accessory_crossmember")
    crossmember_export(len(crossmember_x) - 1);
else if (selected_part == "crossmember_front")
    crossmember_export(0);
else if (selected_part == "crossmember_bow")
    crossmember_export(1);
else if (selected_part == "crossmember_bogie")
    crossmember_export(2);
else if (selected_part == "crossmember_rear")
    crossmember_export(3);
else if (selected_part == "drawbar")
    drawbar();
else if (selected_part == "bogie_arm")
    bogie_arm(1);
else if (selected_part == "bogie_mount")
    translate([-bogie_center_x, -bogie_center_y, -frame_center_z])
        bogie_mount(1);
else if (selected_part == "bogie_travel_review") {
    fender_assembly(1);
    bogie_travel_review(1);
}
else if (selected_part == "bogie_fender_collision")
    intersection() {
        fender_assembly(1);
        bogie_wheel_sweep(1);
    }
else if (selected_part == "wheel")
    wheel();
else if (selected_part == "wheel_tire")
    wheel_tire();
else if (selected_part == "wheel_hub")
    wheel_hub();
else if (selected_part == "wheel_hex_adapter")
    wheel_hex_adapter();
else if (selected_part == "tandem_fender")
    tandem_fender();
else if (selected_part == "fender_mount_bracket")
    fender_mount_bracket(1);
else if (selected_part == "keel_roller")
    keel_roller();
else if (selected_part == "keel_roller_bracket_front")
    keel_roller_bracket_export(0);
else if (selected_part == "keel_roller_bracket_mid_front")
    keel_roller_bracket_export(1);
else if (selected_part == "keel_roller_bracket_mid_rear")
    keel_roller_bracket_export(2);
else if (selected_part == "keel_roller_bracket_rear")
    keel_roller_bracket_export(3);
else if (selected_part == "side_support_receiver")
    translate([-side_support_x[0], -side_support_y, -frame_bottom_z])
        side_support_receiver(0, 1);
else if (selected_part == "side_support_post_front")
    translate([-side_support_x[0], -side_support_y, -frame_bottom_z])
        side_support_post(0, 1);
else if (selected_part == "side_support_post_rear")
    translate([-side_support_x[1], -side_support_y, -frame_bottom_z])
        side_support_post(1, 1);
else if (selected_part == "side_support_roller")
    side_support_roller();
else if (selected_part == "side_roller_wobble_holder")
    side_roller_wobble_holder();
else if (selected_part == "side_double_roller_cradle")
    side_double_roller_cradle();
else if (selected_part == "side_support_front")
    translate([-side_support_x[0], -side_support_y, -frame_bottom_z])
        side_support(0, 1);
else if (selected_part == "side_support_rear")
    translate([-side_support_x[1], -side_support_y, -frame_bottom_z])
        side_support(1, 1);
else if (selected_part == "winch_tower")
    translate([-winch_x, 0, -frame_bottom_z])
        winch_tower();
else if (selected_part == "winch_tower_body")
    translate([-winch_x, 0, -frame_bottom_z])
        winch_tower_body();
else if (selected_part == "winch_drum")
    winch_drum();
else if (selected_part == "winch_crank")
    winch_crank();
else if (selected_part == "bow_stop")
    bow_stop_part();
else if (selected_part == "bow_eye")
    bow_eye_part();
else if (selected_part == "winch_strap_review") {
    winch_tower();
    boat_bow_eye_reference();
}
else if (selected_part == "winch_strap_stop_collision")
    intersection() {
        winch_strap_clearance_envelope();
        union() {
            bow_stop();
            bow_stop_fork();
        }
    }
else if (selected_part == "motor_reference")
    boat_outboard_global_reference();
else if (selected_part == "motor_road_collision")
    intersection() {
        boat_outboard_clearance_envelope();
        translate([trailer_rear_x, 0, ground_z - 50])
            cube([250, 250, 100], center = true);
    }
else if (selected_part == "motor_trailer_collision")
    intersection() {
        boat_outboard_clearance_envelope();
        union() {
            assembled_frame();
            rear_accessories_assembly();
        }
    }
else if (selected_part == "bow_stop_pivot_review") {
    color([0.55, 0.57, 0.60]) winch_tower_body();
    bow_stop_pivot_review();
}
else if (selected_part == "bow_stop_fork_collision")
    for (angle = [-bow_stop_pivot_limit : 1 : bow_stop_pivot_limit])
        intersection() {
            bow_stop_fork();
            bow_stop(angle);
        }
else if (selected_part == "winch_hull_collision")
    intersection() {
        winch_tower_body();
        boat_hull_reference();
    }
else if (selected_part == "bow_stop_hull_contact")
    intersection() {
        bow_stop();
        boat_bow_stop_contact_reference();
    }
else if (selected_part == "rear_light_housing")
    rear_light_housing();
else if (selected_part == "rear_light_lens")
    rear_light_lens();
else if (selected_part == "license_plate_holder")
    license_plate_holder();
else if (selected_part == "hardware_debug")
    trailer_hardware_envelopes();
else
    assert(false, str("Unknown selected_part: ", selected_part));

