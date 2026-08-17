include <config.scad>

module wheel_tire() {
    difference() {
        rotate([90, 0, 0])
            cylinder(h = wheel_width, d = wheel_diameter, center = true);
        rotate([90, 0, 0])
            cylinder(h = wheel_width + 2 * boolean_overlap,
                d = wheel_rim_diameter + 2 * wheel_tire_clearance,
                center = true);
    }
}

module wheel_hub() {
    difference() {
        rotate([90, 0, 0])
            cylinder(h = wheel_rim_width, d = wheel_rim_diameter,
                center = true);
        rotate([90, 0, 0])
            cylinder(h = wheel_rim_width + 2 * boolean_overlap,
                d = wheel_axle_hole, center = true);
        for (angle = [0 : 360 / wheel_spoke_count : 359])
            rotate([0, angle, 0])
                translate([wheel_hub_diameter / 2
                        + (wheel_rim_diameter - wheel_hub_diameter) / 4,
                        0, 0])
                    rotate([90, 0, 0])
                        cylinder(h = wheel_rim_width + 2 * boolean_overlap,
                            d = (wheel_rim_diameter - wheel_hub_diameter) / 3,
                            center = true);
    }
}

module wheel() {
    color([0.08, 0.08, 0.09]) wheel_tire();
    color([0.42, 0.44, 0.47]) wheel_hub();
}


// Separate printed adapter for purchased wheels with a 12 mm hex recess.
// The flange faces the bogie arm; the M4 screw passes through the centre.
module wheel_hex_adapter() {
    adapter_af = wheel_hex_af - 2 * wheel_hex_fit_clearance;
    difference() {
        union() {
            rotate([90, 0, 0])
                cylinder(h = wheel_hex_depth, d = adapter_af / cos(30),
                    center = true, $fn = 6);
            translate([0,
                    -(wheel_hex_depth + wheel_hex_flange_thickness
                        - boolean_overlap) / 2, 0])
                rotate([90, 0, 0])
                    cylinder(h = wheel_hex_flange_thickness
                            + boolean_overlap,
                        d = wheel_hex_flange_diameter, center = true);
            translate([0,
                    -(wheel_hex_depth / 2 + wheel_hex_flange_thickness
                        + wheel_adapter_sleeve_length / 2
                        - boolean_overlap), 0])
                rotate([90, 0, 0])
                    cylinder(h = wheel_adapter_sleeve_length
                            + boolean_overlap,
                        d = wheel_adapter_sleeve_diameter, center = true);
        }
        translate([0,
                -(wheel_hex_flange_thickness
                    + wheel_adapter_sleeve_length) / 2, 0])
            rotate([90, 0, 0])
                cylinder(h = wheel_hex_depth + wheel_hex_flange_thickness
                        + wheel_adapter_sleeve_length + 4 * boolean_overlap,
                    d = wheel_axle_hole, center = true);
    }
}


module wheel_fastener(side = 1) {
    arm_inner_y = side * (bogie_center_y - bogie_arm_thickness / 2);
    nut_outer_y = side * (track_width / 2 + wheel_width / 2
        + wheel_axial_clearance + wheel_washer_thickness
        + wheel_nut_thickness);
    axle_center_y = (arm_inner_y + nut_outer_y) / 2;
    axle_visible_length = abs(nut_outer_y - arm_inner_y);

    color([0.72, 0.72, 0.76]) {
        translate([0, axle_center_y, 0])
            rotate([90, 0, 0])
                cylinder(h = axle_visible_length,
                    d = wheel_axle_diameter, center = true);
        translate([0,
                side * (bogie_center_y + bogie_arm_thickness / 2
                    + wheel_washer_thickness / 2), 0])
            rotate([90, 0, 0])
                cylinder(h = wheel_washer_thickness, d = 9, center = true);
        translate([0,
                side * (track_width / 2 + wheel_width / 2
                    + wheel_axial_clearance
                    + wheel_washer_thickness / 2), 0])
            rotate([90, 0, 0])
                cylinder(h = wheel_washer_thickness, d = 9, center = true);
        translate([0,
                side * (track_width / 2 + wheel_width / 2
                    + wheel_axial_clearance + wheel_washer_thickness
                    + wheel_nut_thickness / 2), 0])
            rotate([90, 0, 0])
                cylinder(h = wheel_nut_thickness,
                    d = wheel_nut_af / cos(30), center = true, $fn = 6);
    }
}

module bogie_arm(side = 1) {
    difference() {
        hull()
            for (x = [-bogie_axle_spacing / 2, 0,
                    bogie_axle_spacing / 2])
                translate([x, 0, x == 0
                        ? bogie_pivot_z - wheel_axis_z : 0])
                    rotate([90, 0, 0])
                        cylinder(h = bogie_arm_thickness,
                            d = bogie_arm_height, center = true);
        for (x = [-bogie_axle_spacing / 2,
                bogie_axle_spacing / 2]) {
            translate([x, 0, 0])
                rotate([90, 0, 0])
                    cylinder(h = bogie_arm_thickness + 2 * boolean_overlap,
                        d = wheel_axle_hole, center = true);
            translate([x, -side * bogie_arm_thickness / 2
                    + side * wheel_axle_head_depth / 2, 0])
                rotate([90, 0, 0])
                    cylinder(h = wheel_axle_head_depth + boolean_overlap,
                        d = wheel_axle_head_af / cos(30),
                        center = true, $fn = 6);
        }
        translate([0, 0, bogie_pivot_z - wheel_axis_z])
            rotate([90, 0, 0])
                cylinder(h = bogie_arm_thickness + 2 * boolean_overlap,
                    d = bogie_pivot_hole, center = true);
    }
}

module bogie_mount(side = 1) {
    rail_outer_y = frame_outer_width / 2;
    inner_ear_y = side * (rail_outer_y
        + bogie_clevis_ear_thickness / 2 - bogie_clevis_rail_overlap);
    outer_ear_y = side * (bogie_center_y + bogie_arm_thickness / 2
        + bogie_clevis_arm_clearance + bogie_clevis_ear_thickness / 2);
    nut_center_y = side * (rail_outer_y + bogie_clevis_ear_thickness
        - bogie_clevis_rail_overlap - bogie_pivot_nut_thickness / 2);
    bridge_z = bogie_pivot_z + bogie_mount_size[2] / 2
        - bogie_clevis_top_bridge_height / 2
        + bogie_clevis_top_bridge_clearance;

    difference() {
        union() {
            for (ear_y = [inner_ear_y, outer_ear_y])
                translate([bogie_center_x, ear_y, bogie_pivot_z])
                    cube([bogie_mount_size[0], bogie_clevis_ear_thickness,
                        bogie_mount_size[2]], center = true);
            translate([bogie_center_x, side * bogie_center_y, bridge_z])
                cube([bogie_mount_size[0], bogie_mount_size[1],
                    bogie_clevis_top_bridge_height], center = true);
            translate([bogie_center_x, side * rail_center_y,
                    frame_bottom_z + rail_size[2]
                        + bogie_clevis_mount_pad_size[2] / 2])
                cube(bogie_clevis_mount_pad_size, center = true);
            for (stop_side = [-1, 1])
                translate([bogie_center_x
                        + stop_side * bogie_stop_pin_radius,
                        side * bogie_center_y,
                        bogie_pivot_z + bogie_stop_pin_z_offset])
                    rotate([90, 0, 0])
                        cylinder(h = bogie_mount_size[1],
                            d = bogie_stop_pin_diameter, center = true);
        }
        translate([bogie_center_x, side * bogie_center_y, bogie_pivot_z])
            rotate([90, 0, 0])
                cylinder(h = bogie_mount_size[1] + 2 * boolean_overlap,
                    d = bogie_pivot_hole, center = true);
        translate([bogie_center_x, nut_center_y, bogie_pivot_z])
            rotate([90, 0, 0])
                cylinder(h = bogie_pivot_nut_thickness + boolean_overlap,
                    d = bogie_pivot_nut_af / cos(30), center = true, $fn = 6);
        for (x = [-bogie_mount_hole_spacing / 2,
                bogie_mount_hole_spacing / 2])
            translate([bogie_center_x + x, side * rail_center_y,
                    frame_bottom_z + rail_size[2]
                        + bogie_clevis_mount_pad_size[2] / 2])
                cylinder(h = bogie_clevis_mount_pad_size[2]
                        + 2 * boolean_overlap,
                    d = m3_clearance, center = true);
        translate([bogie_center_x, side * fender_bracket_rail_hole_y,
                bogie_clevis_top_z])
            cylinder(h = bogie_clevis_top_bridge_height
                    + 2 * boolean_overlap,
                d = fender_mount_hole_diameter, center = true);
    }
}

module bogie_pivot_fastener(side = 1) {
    inner_ear_outer_y = frame_outer_width / 2
        + bogie_clevis_ear_thickness - bogie_clevis_rail_overlap;
    outer_ear_outer_y = bogie_center_y + bogie_arm_thickness / 2
        + bogie_clevis_arm_clearance + bogie_clevis_ear_thickness;
    bolt_center_y = side * (outer_ear_outer_y - bogie_pivot_bolt_length / 2);
    nut_center_y = side * (inner_ear_outer_y - bogie_pivot_nut_thickness / 2);

    color([0.72, 0.72, 0.76]) {
        translate([bogie_center_x, bolt_center_y, bogie_pivot_z])
            rotate([90, 0, 0])
                cylinder(h = bogie_pivot_bolt_length, d = 3, center = true);
        translate([bogie_center_x,
                side * (outer_ear_outer_y + bogie_pivot_bolt_head_thickness / 2),
                bogie_pivot_z])
            rotate([90, 0, 0])
                cylinder(h = bogie_pivot_bolt_head_thickness,
                    d = bogie_pivot_bolt_head_diameter, center = true);
        translate([bogie_center_x, nut_center_y, bogie_pivot_z])
            rotate([90, 0, 0])
                cylinder(h = bogie_pivot_nut_thickness,
                    d = bogie_pivot_nut_af / cos(30), center = true, $fn = 6);
        for (washer_side = [-1, 1])
            translate([bogie_center_x,
                    side * (bogie_center_y + washer_side
                        * (bogie_arm_thickness / 2
                            + bogie_clevis_arm_clearance / 2)),
                    bogie_pivot_z])
                rotate([90, 0, 0])
                    cylinder(h = bogie_pivot_washer_thickness,
                        d = bogie_pivot_washer_diameter, center = true);
    }
}

module bogie_running_gear(side = 1, travel_angle = 0, preview_alpha = 1) {
    translate([bogie_center_x, side * bogie_center_y, bogie_pivot_z])
        rotate([0, travel_angle, 0])
            translate([-bogie_center_x, -side * bogie_center_y, -bogie_pivot_z]) {
                color([0.35, 0.35, 0.38, preview_alpha])
                    translate([bogie_center_x, side * bogie_center_y, wheel_axis_z])
                        bogie_arm(side);
                for (dx = [-bogie_axle_spacing / 2, bogie_axle_spacing / 2]) {
                    color([0.08, 0.08, 0.09, preview_alpha])
                        translate([bogie_center_x + dx, side * track_width / 2, wheel_axis_z])
                            wheel();
                    color([0.72, 0.72, 0.76, preview_alpha])
                        translate([bogie_center_x + dx,
                                side * (track_width / 2 - wheel_width / 2 + wheel_hex_depth / 2),
                                wheel_axis_z])
                            scale([1, side, 1]) wheel_hex_adapter();
                    color([0.72, 0.72, 0.76, preview_alpha])
                        translate([bogie_center_x + dx, 0, wheel_axis_z])
                            wheel_fastener(side);
                }
            }
}

module bogie_assembly(side = 1, travel_angle = 0) {
    bogie_mount(side);
    bogie_running_gear(side, travel_angle);
    bogie_pivot_fastener(side);
}

module bogie_travel_review(side = 1) {
    bogie_mount(side);
    bogie_pivot_fastener(side);
    bogie_running_gear(side, 0, 1);
    for (travel_angle = [-bogie_stop_angle, bogie_stop_angle])
        bogie_running_gear(side, travel_angle, 0.28);
}

module bogie_wheel_sweep(side = 1) {
    for (dx = [-bogie_axle_spacing / 2, bogie_axle_spacing / 2])
        hull()
            for (travel_angle = [-bogie_stop_angle : 2 : bogie_stop_angle])
                translate([bogie_center_x, side * bogie_center_y, bogie_pivot_z])
                    rotate([0, travel_angle, 0])
                        translate([-bogie_center_x, -side * bogie_center_y, -bogie_pivot_z])
                            translate([bogie_center_x + dx, side * track_width / 2, wheel_axis_z])
                                wheel_tire();
}

