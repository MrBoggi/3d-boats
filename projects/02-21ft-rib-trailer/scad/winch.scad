include <config.scad>

module beam_between_xz(a, b, size_x, size_y) {
    hull() {
        translate([a[0], 0, a[1]])
            cube([size_x, size_y, boolean_overlap], center = true);
        translate([b[0], 0, b[1]])
            cube([size_x, size_y, boolean_overlap], center = true);
    }
}

module bow_stop_part() {
    difference() {
        union() {
            rotate([90, 0, 0])
                cylinder(h = bow_stop_mount_hub_width,
                    d = bow_stop_mount_hub_diameter, center = true);
            for (side = [-1, 1])
                hull() {
                    translate(bow_stop_v_vertex)
                        cube([bow_stop_arm_width, bow_stop_arm_width,
                            bow_stop_arm_width], center = true);
                    translate([bow_stop_v_tip[0],
                            side * bow_stop_v_tip[1],
                            bow_stop_v_tip[2]])
                        cube([bow_stop_arm_width, bow_stop_arm_width,
                            bow_stop_arm_width], center = true);
                }
        }
        rotate([90, 0, 0])
            cylinder(h = bow_stop_mount_hub_width
                    + 2 * boolean_overlap,
                d = m3_clearance, center = true);
    }
}

module bow_stop_fork() {
    ear_y = bow_stop_mount_hub_width / 2
        + bow_stop_pivot_clearance + bow_stop_fork_ear_thickness / 2;
    difference() {
        union()
            for (side = [-1, 1])
                hull() {
                    translate([bow_stop_fork_root_x, side * ear_y,
                            bow_stop_center[2]])
                        cube([8, bow_stop_fork_ear_thickness, 10], center = true);
                    translate([bow_stop_center[0], side * ear_y,
                            bow_stop_center[2]])
                        rotate([90, 0, 0])
                            cylinder(h = bow_stop_fork_ear_thickness,
                                d = bow_stop_fork_boss_diameter, center = true);
                }
        translate(bow_stop_center)
            rotate([90, 0, 0])
                cylinder(h = bow_stop_pivot_stack_width
                        + 2 * boolean_overlap,
                    d = m3_clearance, center = true);
    }
}

module bow_stop(angle = bow_stop_work_angle, preview_alpha = 1) {
    color([0.1, 0.1, 0.1, preview_alpha])
        translate(bow_stop_center)
            rotate([0, angle, 0])
                bow_stop_part();
}

module bow_stop_pivot_hardware() {
    pivot_length = bow_stop_pivot_stack_width
        + 2 * bow_stop_pivot_washer_thickness
        + bow_stop_pivot_nut_thickness + 2;
    color([0.72, 0.72, 0.76]) {
        translate(bow_stop_center)
            rotate([90, 0, 0])
                cylinder(h = pivot_length, d = 3, center = true);
        for (side = [-1, 1])
            translate([bow_stop_center[0],
                    side * (bow_stop_pivot_stack_width / 2
                        + bow_stop_pivot_washer_thickness / 2),
                    bow_stop_center[2]])
                rotate([90, 0, 0])
                    cylinder(h = bow_stop_pivot_washer_thickness,
                        d = bow_stop_pivot_washer_diameter, center = true);
        translate([bow_stop_center[0],
                bow_stop_pivot_stack_width / 2
                    + bow_stop_pivot_washer_thickness
                    + bow_stop_pivot_nut_thickness / 2,
                bow_stop_center[2]])
            rotate([90, 0, 0])
                cylinder(h = bow_stop_pivot_nut_thickness,
                    d = bow_stop_pivot_nut_af / cos(30),
                    center = true, $fn = 6);
    }
}

module bow_stop_pivot_review() {
    color([0.55, 0.57, 0.60]) bow_stop_fork();
    bow_stop(0, 1);
    for (angle = [-bow_stop_pivot_limit, bow_stop_pivot_limit])
        bow_stop(angle, 0.25);
    bow_stop_pivot_hardware();
}

module strap_between_points(a, b, width, thickness) {
    hull() {
        translate(a) cube([thickness, width, thickness], center = true);
        translate(b) cube([thickness, width, thickness], center = true);
    }
}

module winch_strap_clearance_envelope() {
    color([1.0, 0.2, 0.1, 0.25])
        strap_between_points(winch_strap_start, winch_strap_end,
            winch_strap_envelope_width, winch_strap_envelope_thickness);
    translate(bow_eye_center)
        rotate([90, 0, 0])
            cylinder(h = winch_hook_width,
                d = winch_hook_outer_diameter, center = true);
}

module winch_hook() {
    color([0.72, 0.72, 0.76])
        translate(bow_eye_center)
            difference() {
                rotate([90, 0, 0])
                    cylinder(h = winch_hook_width,
                        d = winch_hook_outer_diameter, center = true);
                rotate([90, 0, 0])
                    cylinder(h = winch_hook_width + 2 * boolean_overlap,
                        d = winch_hook_inner_diameter, center = true);
                translate([winch_hook_outer_diameter / 2, 0, 0])
                    cube([winch_hook_outer_diameter,
                        winch_hook_width + 2 * boolean_overlap,
                        winch_hook_outer_diameter], center = true);
            }
}

module winch_strap_assembly() {
    color([0.92, 0.34, 0.05])
        strap_between_points(winch_strap_start, winch_strap_end,
            winch_strap_width, winch_strap_thickness);
    winch_hook();
}

module winch_drum() {
    difference() {
        union() {
            rotate([90, 0, 0])
                cylinder(h = winch_drum_width,
                    d = winch_drum_diameter, center = true);
            for (side = [-1, 1])
                translate([0, side * winch_drum_width / 2, 0])
                    rotate([90, 0, 0])
                        cylinder(h = 2, d = winch_drum_flange_diameter,
                            center = true);
        }
        rotate([90, 0, 0])
            cylinder(h = winch_drum_width + 2 * boolean_overlap,
                d = m3_clearance, center = true);
    }
}

module winch_crank() {
    difference() {
        hull() {
            cylinder(h = 4, d = 9, center = true);
            translate([winch_crank_radius, 0, 0])
                cylinder(h = 4, d = winch_handle_diameter, center = true);
        }
        cylinder(h = 6, d = m3_clearance, center = true);
    }
    translate([winch_crank_radius, 0, 5])
        cylinder(h = 12, d = winch_handle_diameter, center = true);
}

module winch_tower_body() {
    difference() {
        union() {
            translate([winch_bridge_x, 0,
                    frame_bottom_z + drawbar_beam_height + 4])
                cube([winch_post_size[0], winch_post_size[1], 8],
                    center = true);
            beam_between_xz(winch_post_base, winch_post_top,
                winch_post_size[0], winch_post_size[1]);
            translate([winch_axis_x, 0,
                    winch_axis_z - winch_seat_size[2] / 2])
                cube(winch_seat_size, center = true);
            beam_between_xz(
                [winch_axis_x + 2, winch_axis_z + 3],
                [bow_stop_fork_root_x, bow_stop_center[2]], 9, 12);
            bow_stop_fork();
            for (side = [-1, 1])
                translate([0, side * 3, 0])
                    beam_between_xz(
                        [winch_brace_lower_x,
                            frame_bottom_z + drawbar_beam_height],
                        winch_brace_upper,
                        winch_brace_size, winch_brace_size);
        }
        translate([winch_axis_x, 0, winch_axis_z])
            rotate([90, 0, 0])
                cylinder(h = winch_post_size[1]
                        + winch_drum_width + 2 * boolean_overlap,
                    d = m3_clearance, center = true);
        translate(bow_stop_center)
            rotate([90, 0, 0])
                cylinder(h = bow_stop_size[1] + 4,
                    d = m3_clearance, center = true);
        translate([winch_bridge_x, 0,
                frame_bottom_z + drawbar_beam_height + 4])
            cylinder(h = 8 + 2 * boolean_overlap,
                d = m3_clearance, center = true);
        for (side = [-1, 1])
            translate([winch_brace_lower_x, side * winch_brace_mount_y,
                    frame_bottom_z + drawbar_beam_height])
                cylinder(h = winch_brace_size + 2 * boolean_overlap,
                    d = m3_clearance, center = true);
    }
}

module winch_tower() {
    color([0.55, 0.57, 0.60]) winch_tower_body();
    color([0.3, 0.3, 0.32])
        translate([winch_axis_x, 0, winch_axis_z]) winch_drum();
    color([0.45, 0.47, 0.50])
        translate([winch_axis_x,
                -winch_drum_width / 2 - 3, winch_axis_z])
            rotate([90, 0, 0]) winch_crank();
    bow_stop();
    bow_stop_pivot_hardware();
    winch_strap_assembly();
}
