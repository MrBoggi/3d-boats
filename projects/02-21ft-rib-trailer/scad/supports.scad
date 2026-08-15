include <config.scad>

module keel_roller() {
    difference() {
        rotate([90, 0, 0])
            rotate_extrude(convexity = 10)
                polygon(points = concat(
                    [[0, -keel_roller_width / 2]],
                    [for (station = keel_roller_profile_stations)
                        [station[1], station[0]]],
                    [[0, keel_roller_width / 2]]));
        rotate([90, 0, 0])
            cylinder(h = keel_roller_width + 2 * boolean_overlap,
                d = keel_roller_axle_hole, center = true);
    }
}

module keel_roller_bracket_side(index = 0, side = 1) {
    assert(index >= 0 && index < len(keel_roller_x));
    axle_z = keel_roller_axle_z[index];
    bracket_mount_z = frame_bottom_z + crossmember_size[2];
    post_height = axle_z - bracket_mount_z;

    difference() {
        union() {
            translate([keel_roller_x[index],
                    side * keel_roller_bracket_hole_y,
                    bracket_mount_z + 2.5])
                cube([12, keel_roller_bracket_foot_width, 5], center = true);
            translate([keel_roller_x[index],
                    side * keel_roller_bracket_arm_y,
                    bracket_mount_z + post_height / 2])
                cube([8, roller_bracket_wall, post_height], center = true);
        }
        translate([keel_roller_x[index],
                side * keel_roller_bracket_arm_y, axle_z])
            rotate([90, 0, 0])
                cylinder(h = roller_bracket_wall + 2 * boolean_overlap,
                    d = keel_roller_axle_hole, center = true);
        translate([keel_roller_x[index],
                side * keel_roller_bracket_hole_y, bracket_mount_z + 2.5])
            cylinder(h = 5 + 2 * boolean_overlap,
                d = m3_clearance, center = true);
    }
}

module keel_roller_bracket(index = 0) {
    for (side = [-1, 1])
        keel_roller_bracket_side(index, side);
}

module keel_roller_bracket_export(index = 0) {
    translate([-keel_roller_x[index], -keel_roller_bracket_hole_y,
            -(frame_bottom_z + crossmember_size[2])])
        keel_roller_bracket_side(index, 1);
}

module keel_roller_assembly(index = 0) {
    keel_roller_bracket(index);
    color([0.1, 0.1, 0.1])
        translate([keel_roller_x[index], 0,
                keel_roller_axle_z[index]])
            keel_roller();
}

module side_support_receiver(index = 0, side = 1) {
    assert(index >= 0 && index < len(side_support_x));
    receiver_bottom_z = frame_bottom_z + crossmember_size[2];
    receiver_z = receiver_bottom_z + support_receiver_size[2] / 2;
    difference() {
        union() {
            translate([side_support_x[index], side * side_support_y,
                    receiver_bottom_z + support_receiver_mount_size[2] / 2])
                cube(support_receiver_mount_size, center = true);
            translate([side_support_x[index], side * side_support_y, receiver_z])
                cube(support_receiver_size, center = true);
        }
        translate([side_support_x[index], side * side_support_y,
                receiver_z + support_receiver_wall])
            cube([support_post_size[0] + 2 * fit_clearance,
                support_post_size[1] + 2 * fit_clearance,
                support_receiver_size[2]], center = true);
        translate([side_support_x[index], side * side_support_y,
                frame_bottom_z + crossmember_size[2] + support_adjustment_pitch])
            rotate([90, 0, 0])
                cylinder(h = support_receiver_size[1] + 2 * boolean_overlap,
                    d = support_adjustment_hole, center = true);
        for (hole_y = [-support_receiver_mount_hole_spacing / 2,
                support_receiver_mount_hole_spacing / 2])
            translate([side_support_x[index],
                    side * side_support_y + hole_y,
                    receiver_bottom_z + support_receiver_mount_size[2] / 2])
                cylinder(h = support_receiver_mount_size[2]
                        + 2 * boolean_overlap,
                    d = m3_clearance, center = true);
    }
}

module side_support_post(index = 0, side = 1) {
    assert(index >= 0 && index < len(side_support_x));
    post_bottom_z = frame_bottom_z + crossmember_size[2]
        + support_receiver_wall;
    post_height = side_support_top_z[index] - post_bottom_z;
    difference() {
        translate([side_support_x[index], side * side_support_y,
                post_bottom_z + post_height / 2])
            cube([support_post_size[0], support_post_size[1], post_height],
                center = true);
        for (hole_index = [0 : support_adjustment_count - 1])
            translate([side_support_x[index], side * side_support_y,
                    frame_bottom_z + crossmember_size[2] + support_adjustment_pitch
                        + hole_index * support_adjustment_pitch])
                rotate([90, 0, 0])
                    cylinder(h = support_post_size[1]
                            + 2 * boolean_overlap,
                        d = support_adjustment_hole, center = true);
        translate([side_support_x[index], side * side_support_y,
                side_support_top_z[index]])
            rotate([90, 0, 0])
                cylinder(h = support_post_size[1] + 2 * boolean_overlap,
                    d = support_pad_pivot_hole, center = true);
    }
}

module side_support_roller() {
    difference() {
        rotate([90, 0, 0])
            rotate_extrude(convexity = 10)
                polygon(points = concat(
                    [[0, -side_roller_width / 2]],
                    [for (station = side_roller_profile_stations)
                        [station[1], station[0]]],
                    [[0, side_roller_width / 2]]));
        rotate([90, 0, 0])
            cylinder(h = side_roller_width + 2 * boolean_overlap,
                d = side_roller_axle_hole, center = true);
    }
}

module side_roller_wobble_holder() {
    difference() {
        union() {
            translate([0, 0, side_roller_holder_pivot_z])
                cube(side_roller_holder_size, center = true);
            for (roller_side = [-1, 1])
                translate([0,
                        roller_side * (side_roller_width / 2
                            + side_roller_holder_lug_wall / 2 + fit_clearance),
                        (side_roller_holder_pivot_z
                            + side_roller_holder_axis_z) / 2])
                    cube([side_roller_holder_size[0],
                        side_roller_holder_lug_wall,
                        side_roller_holder_axis_z
                            - side_roller_holder_pivot_z
                            + side_roller_diameter / 2], center = true);
        }
        rotate([0, 90, 0])
            cylinder(h = side_roller_holder_size[0] + 2 * boolean_overlap,
                d = side_roller_holder_pivot_hole, center = true);
        translate([0, 0, side_roller_holder_axis_z])
            rotate([90, 0, 0])
                cylinder(h = side_roller_width
                        + 2 * side_roller_holder_lug_wall
                        + 2 * fit_clearance + 2 * boolean_overlap,
                    d = side_roller_axle_hole, center = true);
    }
}

module side_double_roller_cradle() {
    difference() {
        union() {
            cube(side_roller_cradle_size, center = true);
            for (roller_x = [-side_roller_spacing_x / 2,
                    side_roller_spacing_x / 2])
                for (stop_side = [-1, 1]) {
                    translate([roller_x,
                            stop_side * (side_roller_holder_size[1] / 2
                                + side_roller_stop_clearance
                                + side_roller_stop_width / 2),
                            side_roller_holder_mount_z])
                        cube([side_roller_holder_size[0],
                            side_roller_stop_width, side_roller_stop_height],
                            center = true);
                    translate([roller_x,
                            stop_side * (side_roller_holder_size[1] / 2
                                + side_roller_stop_clearance / 2),
                            side_roller_cradle_size[2] / 2
                                + side_roller_stop_foot_height / 2
                                - boolean_overlap])
                        cube([side_roller_holder_size[0],
                            side_roller_stop_clearance
                                + side_roller_stop_width,
                            side_roller_stop_foot_height], center = true);
                }
        }
        rotate([90, 0, 0])
            cylinder(h = side_roller_cradle_size[1] + 2 * boolean_overlap,
                d = support_pad_pivot_hole, center = true);
        for (roller_x = [-side_roller_spacing_x / 2,
                side_roller_spacing_x / 2])
            translate([roller_x, 0, side_roller_holder_mount_z])
                rotate([0, 90, 0])
                    cylinder(h = side_roller_holder_size[0]
                            + 2 * boolean_overlap,
                        d = side_roller_holder_pivot_hole, center = true);
    }
}

module side_double_roller_assembly(index = 0) {
    color([0.38, 0.40, 0.43]) side_double_roller_cradle();
    for (i = [0 : 1]) {
        roller_x = [-side_roller_spacing_x / 2,
            side_roller_spacing_x / 2][i];
        wobble_angle = show_side_contact_debug
            ? side_roller_debug_angles[index][i]
            : side_roller_work_angles[index][i];
        translate([roller_x, 0, side_roller_holder_mount_z])
            rotate([wobble_angle, 0, 0]) {
                color([0.48, 0.50, 0.53])
                    side_roller_wobble_holder();
                color([0.10, 0.10, 0.10])
                    translate([0, 0, side_roller_holder_axis_z])
                        side_support_roller();
            }
    }
}

module side_support(index = 0, side = 1) {
    side_support_receiver(index, side);
    side_support_post(index, side);
    debug_drop = show_side_contact_debug
        ? side_support_debug_clearance - side_support_work_clearance : 0;
    translate([side_support_x[index], side * side_support_y,
            side_support_top_z[index] - debug_drop])
        rotate([side * side_support_angle, side_support_pitch[index], 0])
            side_double_roller_assembly(index);
}

module supports_assembly() {
    for (index = [0 : len(keel_roller_x) - 1])
        keel_roller_assembly(index);
    for (index = [0 : len(side_support_x) - 1])
        for (side = [-1, 1])
            side_support(index, side);
}

