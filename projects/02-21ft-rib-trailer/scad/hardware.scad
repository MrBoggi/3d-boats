include <config.scad>

module axle_envelope(length = 36, diameter = m3_clearance) {
    rotate([90, 0, 0])
        cylinder(h = length, d = diameter, center = true);
}

module wheel_nut_envelope(side = 1) {
    translate([0, side * (wheel_width / 2 + wheel_axial_clearance
            + wheel_nut_thickness / 2), 0])
        rotate([90, 0, 0])
            cylinder(h = wheel_nut_thickness,
                d = wheel_nut_af / cos(30), center = true, $fn = 6);
}

module bogie_hardware_envelopes() {
    color([0.9, 0.7, 0.2, 0.7]) {
        for (side = [-1, 1]) {
            translate([bogie_center_x, side * bogie_center_y,
                    bogie_pivot_z])
                axle_envelope(24, bogie_pivot_hole);
            for (dx = [-bogie_axle_spacing / 2,
                    bogie_axle_spacing / 2]) {
                translate([bogie_center_x + dx,
                        side * track_width / 2, wheel_axis_z])
                    axle_envelope(wheel_axle_length, wheel_axle_diameter);
                translate([bogie_center_x + dx,
                        side * track_width / 2, wheel_axis_z])
                    wheel_nut_envelope(side);
            }
            for (mount_x = [bogie_center_x - bogie_mount_hole_spacing / 2,
                    bogie_center_x + bogie_mount_hole_spacing / 2])
                translate([mount_x, side * rail_center_y,
                        frame_bottom_z + (rail_size[2]
                            + bogie_clevis_mount_pad_size[2]) / 2])
                    cylinder(h = bogie_mount_fastener_length,
                        d = m3_clearance, center = true);
        }
    }
}


module coupler_hardware_envelopes() {
    color([0.9, 0.7, 0.2, 0.7]) {
        translate([coupler_adapter_center_x
                - coupler_adapter_size[0] / 2
                - coupler_stud_projection / 2, 0, coupler_axis_z])
            rotate([0, 90, 0])
                cylinder(h = coupler_adapter_size[0]
                        + coupler_stud_projection + 6,
                    d = coupler_stud_diameter, center = true);
        for (hole_x = [coupler_adapter_center_x
                    + coupler_frame_hole_first_x,
                coupler_adapter_center_x + coupler_frame_hole_first_x
                    + coupler_frame_hole_spacing])
            translate([hole_x, 0, coupler_axis_z])
                cylinder(h = drawbar_beam_height + 8,
                    d = coupler_frame_hole_diameter, center = true);
    }
}

module frame_hardware_envelopes() {
    color([0.9, 0.7, 0.2, 0.7]) {
        for (seam_x = [2 * frame_segment_length])
            for (side = [-1, 1])
                for (x = [-splice_hole_spacing / 2,
                        splice_hole_spacing / 2])
                    translate([seam_x + x, side * rail_center_y,
                            frame_center_z])
                        axle_envelope(rail_size[1] + 2 * splice_size[1] + 8,
                            splice_hole_diameter);
        for (side = [-1, 1])
            for (hole_x = [v_split_x - v_joint_hole_spacing / 2,
                    v_split_x + v_joint_hole_spacing / 2])
                translate([hole_x, side * v_half_width_at(hole_x),
                        frame_bottom_z + drawbar_beam_height / 2])
                    cylinder(h = drawbar_beam_height + 8,
                        d = v_joint_hole_diameter, center = true);
        for (side = [-1, 1])
            for (point = [[v_rail_joint_front_x,
                        side * v_half_width_at(v_rail_joint_front_x)],
                    [v_rear_x, side * rail_center_y],
                    [v_rail_joint_rear_x, side * rail_center_y]])
                translate([point[0], point[1], frame_center_z])
                    cylinder(h = drawbar_beam_height
                            + 2 * v_rail_joint_plate_thickness + 8,
                        d = m3_clearance, center = true);
        for (member_x = crossmember_x)
            for (side = [-1, 1])
                translate([member_x, side * rail_center_y, frame_center_z])
                    cylinder(h = rail_size[2] + 8, d = m3_clearance,
                        center = true);
    }
}

module support_hardware_envelopes() {
    color([0.9, 0.7, 0.2, 0.7]) {
        for (index = [0 : len(keel_roller_x) - 1])
            translate([keel_roller_x[index], 0,
                    keel_roller_axle_z[index]])
                axle_envelope(keel_roller_width + 12, keel_roller_axle_hole);
        for (roller_x = keel_roller_x)
            for (side = [-1, 1])
                translate([roller_x, side * 12, frame_center_z])
                    cylinder(h = crossmember_size[2] + 10,
                        d = m3_clearance, center = true);
        for (index = [0 : len(side_support_x) - 1])
            for (side = [-1, 1]) {
                translate([side_support_x[index], side * side_support_y,
                        frame_bottom_z + crossmember_size[2] + support_adjustment_pitch])
                    axle_envelope(support_receiver_size[1] + 10, support_adjustment_hole);
                for (hole_y = [-support_receiver_mount_hole_spacing / 2,
                        support_receiver_mount_hole_spacing / 2])
                    translate([side_support_x[index],
                            side * side_support_y + hole_y,
                            frame_bottom_z + crossmember_size[2]])
                        cylinder(h = crossmember_size[2]
                                + support_receiver_mount_size[2] + 8,
                            d = m3_clearance, center = true);
                translate([side_support_x[index], side * side_support_y,
                        side_support_top_z[index]])
                    rotate([90, 0, 0])
                        cylinder(h = support_post_size[1]
                                + side_roller_cradle_size[0] + 8,
                            d = support_pad_pivot_hole, center = true);
                translate([side_support_x[index], side * side_support_y,
                        side_support_top_z[index]])
                    rotate([side * side_support_angle, side_support_pitch[index], 0])
                        for (roller_x = [-side_roller_spacing_x / 2,
                                side_roller_spacing_x / 2])
                            translate([roller_x, 0,
                                    side_support_roller_axis_z])
                                axle_envelope(side_roller_width + 12, side_roller_axle_hole);
                translate([side_support_x[index], side * side_support_y,
                        side_support_top_z[index]])
                    rotate([side * side_support_angle, side_support_pitch[index], 0])
                        for (roller_x = [-side_roller_spacing_x / 2,
                                side_roller_spacing_x / 2])
                            translate([roller_x, 0, side_roller_holder_mount_z])
                                rotate([0, 90, 0])
                                    cylinder(h = side_roller_holder_size[0] + 8,
                                        d = side_roller_holder_pivot_hole,
                                        center = true);
            }
    }
}


module fender_hardware_envelopes() {
    color([0.9, 0.7, 0.2, 0.7])
        for (side = [-1, 1]) {
            translate([bogie_center_x,
                    side * fender_bracket_rail_hole_y,
                    fender_bracket_z])
                cylinder(h = fender_bracket_size[2] + 8,
                    d = fender_mount_hole_diameter, center = true);
            translate([bogie_center_x,
                    side * (fender_bracket_center_y
                        + fender_bracket_size[1] / 2
                        - fender_bracket_flange_thickness / 2),
                    fender_bracket_z + fender_bracket_hole_local_z])
                rotate([90, 0, 0])
                    cylinder(h = fender_bracket_flange_thickness + 8,
                        d = fender_mount_hole_diameter, center = true);
        }
}

module winch_hardware_envelope() {
    color([0.9, 0.7, 0.2, 0.7]) {
        translate([winch_axis_x, 0, winch_axis_z])
            axle_envelope(winch_drum_width + 14, m3_clearance);
        translate([winch_bridge_x, 0,
                frame_bottom_z + drawbar_beam_height / 2])
            cylinder(h = drawbar_beam_height + 16,
                d = m3_clearance, center = true);
        for (side = [-1, 1])
            translate([winch_brace_lower_x, side * winch_brace_mount_y,
                    frame_bottom_z + drawbar_beam_height / 2])
                cylinder(h = drawbar_beam_height + winch_brace_size + 8,
                    d = m3_clearance, center = true);
        translate(bow_stop_center)
            axle_envelope(bow_stop_size[1] + 12, m3_clearance);
    }
}

module rear_accessory_hardware_envelopes() {
    color([0.9, 0.7, 0.2, 0.7]) {
        for (side = [-1, 1])
            for (offset_z = [-rear_light_mount_spacing_z / 2,
                    rear_light_mount_spacing_z / 2])
                translate([rear_accessory_x,
                        side * rear_light_y,
                        frame_bottom_z + crossmember_size[2] / 2
                            + offset_z])
                    rotate([0, 90, 0])
                        cylinder(h = crossmember_size[0]
                                + rear_light_housing_size[0] + 8,
                            d = rear_accessory_hole_diameter, center = true);
        for (side = [-1, 1])
            for (offset_y = [-rear_light_lens_hole_spacing_y / 2,
                    rear_light_lens_hole_spacing_y / 2])
                translate([rear_accessory_x + crossmember_size[0] / 2
                            + rear_light_housing_size[0],
                        side * rear_light_y + offset_y,
                        frame_bottom_z + crossmember_size[2] / 2])
                    rotate([0, 90, 0])
                        cylinder(h = rear_light_housing_size[0]
                                + rear_light_lens_size[0] + 6,
                            d = rear_light_lens_clearance_hole, center = true);
        for (offset_y = [-license_plate_hole_spacing_y / 2,
                license_plate_hole_spacing_y / 2])
            translate([rear_accessory_x,
                    license_plate_center_y + offset_y,
                    frame_bottom_z + crossmember_size[2] / 2])
                rotate([0, 90, 0])
                    cylinder(h = crossmember_size[0]
                            + license_plate_size[0] + 8,
                        d = rear_accessory_hole_diameter, center = true);
    }
}

module trailer_hardware_envelopes() {
    bogie_hardware_envelopes();
    coupler_hardware_envelopes();
    frame_hardware_envelopes();
    support_hardware_envelopes();
    fender_hardware_envelopes();
    winch_hardware_envelope();
    rear_accessory_hardware_envelopes();
}

