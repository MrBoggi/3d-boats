include <config.scad>

module coupler_mount_adapter() {
    difference() {
        union() {
            cube(coupler_adapter_size, center = true);
            translate([coupler_adapter_size[0] / 2
                    + coupler_tongue_length / 2 - boolean_overlap, 0, 0])
                cube(coupler_tongue_size, center = true);
        }
        rotate([0, 90, 0])
            cylinder(h = coupler_adapter_size[0]
                    + 2 * boolean_overlap,
                d = coupler_m3_clearance, center = true);
        translate([coupler_adapter_size[0] / 2
                - coupler_bolt_head_depth / 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = coupler_bolt_head_depth
                        + boolean_overlap,
                    d = coupler_bolt_head_af / cos(30),
                    center = true, $fn = 6);
        for (hole_x = [coupler_frame_hole_first_x,
                coupler_frame_hole_first_x + coupler_frame_hole_spacing])
            translate([hole_x, 0, 0])
                cylinder(h = coupler_tongue_size[2]
                        + 2 * boolean_overlap,
                    d = coupler_frame_hole_diameter, center = true);
    }
}

module coupler_m3_stud_reference() {
    color([0.72, 0.72, 0.76, 0.8])
        translate([-coupler_adapter_size[0] / 2
                - coupler_stud_projection / 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = coupler_stud_projection,
                    d = coupler_stud_diameter, center = true);
}

module purchased_coupler_envelope() {
    // Conservative envelope for a ~35 mm long M3 trailer claw.
    color([0.22, 0.22, 0.24, 0.65]) {
        translate([-coupler_adapter_size[0] / 2
                - coupler_claw_length / 2, 0, 0])
            hull() {
                translate([coupler_claw_length / 2 - 5, 0, 0])
                    rotate([0, 90, 0])
                        cylinder(h = coupler_claw_length - 10,
                            d = coupler_claw_body_diameter, center = true);
                translate([-coupler_claw_length / 2 + 5, 0, 0])
                    sphere(d = coupler_claw_outer_diameter);
            }
        translate([-coupler_adapter_size[0] / 2
                - coupler_claw_length + 5, 0, 0])
            difference() {
                sphere(d = coupler_claw_outer_diameter);
                sphere(d = coupler_ball_diameter
                    + 2 * coupler_ball_clearance);
                translate([-coupler_claw_outer_diameter / 2, 0, 0])
                    cube([coupler_claw_outer_diameter,
                        coupler_claw_outer_diameter,
                        coupler_claw_outer_diameter], center = true);
            }
    }
}

module coupler_assembly() {
    translate([coupler_adapter_center_x, 0, coupler_axis_z]) {
        color([0.50, 0.52, 0.55]) coupler_mount_adapter();
        if (show_coupler_reference) {
            coupler_m3_stud_reference();
            purchased_coupler_envelope();
        }
    }
}
