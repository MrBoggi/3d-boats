include <config.scad>

// Zodiac-inspired removable helm bench for driver and first passenger.
// X is bow to stern, Y is port to starboard and Z is up.

module bench_rounded_box(size, radius) {
    hull()
        for (x = [-size[0] / 2 + radius,
                size[0] / 2 - radius])
            for (y = [-size[1] / 2 + radius,
                    size[1] / 2 - radius])
                translate([x, y, 0])
                    cylinder(h = size[2], r = radius,
                        center = true, $fn = 28);
}

module bench_tube_between(a, b, diameter = helm_bench_tube_diameter) {
    hull() {
        translate(a) sphere(d = diameter, $fn = 20);
        translate(b) sphere(d = diameter, $fn = 20);
    }
}

module helm_bench_cushion_part() {
    translate([
        helm_bench_center_x,
        helm_bench_center_y,
        helm_bench_seat_top_z - helm_bench_seat_size[2] / 2
    ])
        bench_rounded_box(helm_bench_seat_size,
            helm_bench_seat_corner_radius);
}

module bench_side_profile_2d() {
    // Sheet-like Zodiac frame: two legs, a diagonal brace and an upper cheek.
    union() {
        polygon(points = [
            [-17, 35], [-13, 42], [14, 42], [18, 38], [17, 34],
            [-12, 34]
        ]);
        polygon(points = [
            [-16, 36], [-13, 0], [-6, 0], [-7, 34]
        ]);
        polygon(points = [
            [9, 36], [11, 0], [18, 0], [17, 38]
        ]);
        hull() {
            translate([-9, 25]) circle(r = 2.6, $fn = 20);
            translate([13, 10]) circle(r = 2.6, $fn = 20);
        }
    }
}

module helm_bench_side_frame_part(side = 1) {
    side_y = helm_bench_center_y
        + side * helm_bench_frame_spacing / 2;

    union() {
        translate([
            helm_bench_center_x,
            side_y + helm_bench_frame_thickness / 2,
            cockpit_floor_z + helm_bench_foot_size[2]
        ])
            rotate([90, 0, 0])
                linear_extrude(height = helm_bench_frame_thickness)
                    bench_side_profile_2d();

        // Two feet per side accept M2 screws into heat-set inserts in the sole.
        for (x_offset = helm_bench_foot_x_offsets)
            difference() {
                translate([
                    helm_bench_center_x + x_offset,
                    side_y,
                    cockpit_floor_z + helm_bench_foot_size[2] / 2
                ])
                    bench_rounded_box(helm_bench_foot_size, 2);
                for (hole_x = [-helm_bench_foot_hole_spacing_x / 2,
                        helm_bench_foot_hole_spacing_x / 2])
                    translate([
                        helm_bench_center_x + x_offset + hole_x,
                        side_y,
                        cockpit_floor_z + helm_bench_foot_size[2] / 2
                    ])
                        cylinder(h = helm_bench_foot_size[2]
                                + 2 * boolean_overlap,
                            d = helm_bench_floor_pilot_diameter,
                            center = true, $fn = 20);
            }
    }
}

module helm_bench_cross_braces_part() {
    y0 = helm_bench_center_y - helm_bench_frame_spacing / 2;
    y1 = helm_bench_center_y + helm_bench_frame_spacing / 2;
    for (xz = [[-12, 13], [10, 29]])
        bench_tube_between(
            [helm_bench_center_x + xz[0], y0,
                cockpit_floor_z + xz[1]],
            [helm_bench_center_x + xz[0], y1,
                cockpit_floor_z + xz[1]]);
}

module helm_bench_side_rails_part() {
    for (side = [-1, 1]) {
        y = helm_bench_center_y
            + side * helm_bench_frame_spacing / 2;
        z = helm_bench_seat_top_z + 4;
        bench_tube_between(
            [helm_bench_center_x - 15, y, z - 2],
            [helm_bench_center_x - 10, y, z + 4]);
        bench_tube_between(
            [helm_bench_center_x - 10, y, z + 4],
            [helm_bench_center_x + 15, y, z + 4]);
        bench_tube_between(
            [helm_bench_center_x + 15, y, z + 4],
            [helm_bench_center_x + 16, y, z]);
    }
}

module helm_bench_floor_insert_references() {
    for (side = [-1, 1])
        for (x_offset = helm_bench_foot_x_offsets)
            for (hole_x = [-helm_bench_foot_hole_spacing_x / 2,
                    helm_bench_foot_hole_spacing_x / 2])
            translate([
                helm_bench_center_x + x_offset + hole_x,
                helm_bench_center_y
                    + side * helm_bench_frame_spacing / 2,
                cockpit_floor_z - helm_bench_floor_insert_depth / 2
            ])
                cylinder(h = helm_bench_floor_insert_depth,
                    d = helm_bench_floor_insert_diameter,
                    center = true, $fn = 24);
}

module helm_bench_stage1_assembly() {
    color([0.04, 0.05, 0.06]) {
        helm_bench_side_frame_part(-1);
        helm_bench_side_frame_part(1);
        helm_bench_cross_braces_part();
        helm_bench_side_rails_part();
    }
    color([0.86, 0.87, 0.88])
        helm_bench_cushion_part();
}
