include <config.scad>

module aft_rounded_box(size, radius) {
    hull()
        for (x = [-size[0] / 2 + radius,
                size[0] / 2 - radius])
            for (y = [-size[1] / 2 + radius,
                    size[1] / 2 - radius])
                translate([x, y, 0])
                    cylinder(h = size[2], r = radius,
                        center = true, $fn = 30);
}

module aft_tube_between(a, b, diameter = 3) {
    hull() {
        translate(a) sphere(d = diameter, $fn = 20);
        translate(b) sphere(d = diameter, $fn = 20);
    }
}

module aft_bench_servo_cover_part() {
    difference() {
        translate(aft_seat_cover_center)
            aft_rounded_box(aft_seat_cover_size, 5);

        // Bottom access cavity; the roof remains closed below the seat.
        translate([
            steering_servo_axis[0], 0,
            cockpit_floor_z + aft_seat_service_clearance[2] / 2
                - boolean_overlap
        ])
            cube(aft_seat_service_clearance, center = true);

        for (x = aft_seat_mount_x)
            for (y = aft_seat_mount_y)
                translate([x, y, cockpit_floor_z + 8])
                    cylinder(h = 20,
                        d = aft_seat_mount_pilot_diameter,
                        center = true, $fn = 20);
    }
}

module aft_center_seat_cushion() {
    translate([
        aft_seat_center[0], 0,
        aft_seat_cushion_top_z
            - aft_seat_center_cushion_size[2] / 2
    ])
        aft_rounded_box(aft_seat_center_cushion_size, 5);
}

module aft_wing_cushion(side) {
    // The outboard end narrows and moves aft to follow the pontoon/transom.
    z = aft_seat_cushion_top_z - 3.5;
    hull() {
        for (p = [[516, side * 40], [558, side * 40],
                [508, side * 68], [552, side * 68]])
            translate([p[0], p[1], z])
                cylinder(h = 7, r = 4, center = true, $fn = 24);
    }
}

module aft_bench_cushion_part() {
    aft_center_seat_cushion();
    aft_wing_cushion(-1);
    aft_wing_cushion(1);
}

module aft_bench_backrest_part() {
    // Sculpted centre: curved shoulders and a shallow raised crown.
    hull()
        for (node = [[-33, 3], [33, 3], [-31, 24],
                [0, 29], [31, 24]])
            translate([
                aft_seat_back_center_x,
                node[0],
                aft_seat_cushion_top_z + node[1]
            ])
                rotate([0, 90 + aft_seat_back_angle, 0])
                    cylinder(h = aft_seat_center_back_size[0],
                        d = 6, center = true, $fn = 24);

    // The side backs taper down and curve out toward the pontoons.
    for (side = [-1, 1])
        hull()
            for (node = [[38, 3, 0], [64, 5, -3],
                    [38, 23, 0], [62, 18, -4]])
                translate([
                    aft_seat_back_center_x + node[2],
                    side * node[0],
                    aft_seat_cushion_top_z + node[1]
                ])
                    rotate([0, 90 + aft_seat_back_angle, 0])
                        cylinder(h = aft_seat_wing_back_size[0],
                            d = 6, center = true, $fn = 24);
}

module aft_bench_moulded_side_support(side) {
    // Solid molded side pedestal curves up beneath each pontoon-side wing.
    hull() {
        translate([532, side * 55, cockpit_floor_z + 8])
            cube([44, 26, 16], center = true);
        translate([536, side * 55, aft_seat_cushion_top_z - 8])
            cube([56, 28, 8], center = true);
    }
}

module aft_bench_seat_support_part() {
    // Continuous upper apron makes the complete area below the seat solid.
    color([0.52, 0.54, 0.56])
        translate([536, 0, aft_seat_cushion_top_z - 9])
            aft_rounded_box([58, 136, 10], 5);

    color([0.52, 0.54, 0.56]) {
        aft_bench_moulded_side_support(-1);
        aft_bench_moulded_side_support(1);
    }

    // Discreet backrest hinge rail, mostly hidden by the cushions.
    color([0.04, 0.05, 0.06]) {
        aft_tube_between([568, -64, 88], [568, 64, 88], 3);
        for (y = [-47, -30, 0, 30, 47])
            aft_tube_between([568, y, 87], [572, y, 99], 2.5);
    }
}

module aft_bench_insert_references() {
    for (x = aft_seat_mount_x)
        for (y = aft_seat_mount_y)
            translate([x, y,
                    cockpit_floor_z - aft_seat_insert_depth / 2])
                cylinder(h = aft_seat_insert_depth,
                    d = aft_seat_insert_diameter,
                    center = true, $fn = 24);
}

module aft_bench_servo_clearance_reference() {
    color([0.90, 0.18, 0.12, 0.30])
        translate([
            steering_servo_axis[0], 0,
            cockpit_floor_z + aft_seat_service_clearance[2] / 2
        ])
            cube(aft_seat_service_clearance, center = true);
}

module aft_bench_stage1_assembly() {
    color([0.25, 0.27, 0.30])
        aft_bench_servo_cover_part();
    aft_bench_seat_support_part();
    color([0.86, 0.87, 0.88]) {
        aft_bench_cushion_part();
        aft_bench_backrest_part();
    }
}
