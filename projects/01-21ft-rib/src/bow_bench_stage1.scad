include <config.scad>

module bow_node(x, y, z, diameter = 2 * bow_bench_corner_radius) {
    translate([x, y, z])
        cylinder(h = 1, d = diameter, center = true, $fn = 28);
}

module bow_bench_planform(z, height, inset = 0) {
    hull() {
        bow_node(bow_bench_nose_x, 0, z,
            2 * max(1, bow_bench_nose_radius - inset));
        for (side = [-1, 1]) {
            bow_node(bow_bench_forward_x,
                side * (bow_bench_forward_half_width - inset), z,
                2 * max(1, bow_bench_corner_radius - inset));
            bow_node(bow_bench_aft_x,
                side * (bow_bench_aft_half_width - inset), z,
                2 * max(1, bow_bench_corner_radius - inset));
        }
    }
}

module bow_bench_locker_base_part() {
    hull() {
        // Lower nodes follow the rising bow floor. This removes the low,
        // unsupported wedge that previously projected beneath the tubes.
        bow_node(bow_bench_nose_x, 0,
            bow_bench_base_forward_bottom_z,
            2 * max(1, bow_bench_nose_radius - 4));
        for (side = [-1, 1]) {
            bow_node(bow_bench_forward_x,
                side * (bow_bench_forward_half_width - 4),
                bow_bench_base_forward_bottom_z,
                2 * max(1, bow_bench_corner_radius - 4));
            bow_node(bow_bench_aft_x,
                side * (bow_bench_aft_half_width - 4),
                bow_bench_base_aft_bottom_z,
                2 * max(1, bow_bench_corner_radius - 4));
        }

        bow_node(bow_bench_nose_x, 0, bow_bench_base_top_z,
            2 * bow_bench_nose_radius);
        for (side = [-1, 1]) {
            bow_node(bow_bench_forward_x,
                side * bow_bench_forward_half_width,
                bow_bench_base_top_z,
                2 * bow_bench_corner_radius);
            bow_node(bow_bench_aft_x,
                side * bow_bench_aft_half_width,
                bow_bench_base_top_z,
                2 * bow_bench_corner_radius);
        }
    }
}

module bow_bench_cushion_part() {
    hull() {
        translate([
            bow_bench_nose_x, 0,
            bow_bench_top_z - bow_bench_cushion_thickness / 2
        ])
            cylinder(h = bow_bench_cushion_thickness,
                r = bow_bench_nose_radius, center = true, $fn = 30);
        for (side = [-1, 1]) {
            translate([
                bow_bench_forward_x,
                side * bow_bench_forward_half_width,
                bow_bench_top_z - bow_bench_cushion_thickness / 2
            ])
                cylinder(h = bow_bench_cushion_thickness,
                    r = bow_bench_corner_radius, center = true, $fn = 30);
            translate([
                bow_bench_aft_x,
                side * bow_bench_aft_half_width,
                bow_bench_top_z - bow_bench_cushion_thickness / 2
            ])
                cylinder(h = bow_bench_cushion_thickness,
                    r = bow_bench_corner_radius, center = true, $fn = 30);
        }
    }
}

module bow_rail_segment(a, b, diameter = bow_rail_diameter) {
    hull() {
        translate(a) sphere(d = diameter, $fn = 20);
        translate(b) sphere(d = diameter, $fn = 20);
    }
}

module bow_single_rail_side_part(side) {
    rail = [
        for (point = bow_rail_path)
            [point[0], side * point[1], point[2]]
    ];
    foot = [bow_rail_foot_xy[0], side * bow_rail_foot_xy[1], cockpit_floor_z + bow_deck_height];

    union() {
    for (i = [0 : len(rail) - 2])
        bow_rail_segment(rail[i], rail[i + 1]);

    bow_rail_segment(foot, rail[0]);
    bow_rail_segment(foot,
        [foot[0], foot[1], foot[2] - bow_rail_tenon_length],
        bow_rail_tenon_diameter);
    }
}

module bow_anchor_well_reference() {
    color([0.10, 0.11, 0.12])
        difference() {
            hull()
                for (x_y = [[4, 14], [32, 22]])
                    for (side = [-1, 1])
                        translate([x_y[0], side * x_y[1], 108])
                            cylinder(h = 8, r = 3, center = true, $fn = 24);
            hull()
                for (x_y = [[8, 9], [28, 17]])
                    for (side = [-1, 1])
                        translate([x_y[0], side * x_y[1], 111])
                            cylinder(h = 7, r = 2, center = true, $fn = 20);
        }
}

module bow_anchor_roller_part() {
    // Two cheeks capture a transverse roller at the blunt bow.
    color([0.05, 0.06, 0.07]) {
        for (side = [-1, 1])
            hull() {
                translate([5, side * 13, 109])
                    sphere(d = 4, $fn = 20);
                translate([25, side * 20, 118])
                    sphere(d = 4, $fn = 20);
                translate([24, side * 20, 113])
                    sphere(d = 4, $fn = 20);
            }
    }
    color([0.72, 0.74, 0.76])
        translate([7, 0, 114])
            rotate([90, 0, 0])
                cylinder(h = 30, d = 6, center = true, $fn = 28);
}

module bow_railing_assembly_reference() {
    bow_anchor_well_reference();
    for (side = [-1, 1])
        bow_single_rail_side_part(side);
    bow_anchor_roller_part();
}

module bow_bench_stage1_assembly() {
    color([0.52, 0.54, 0.56])
        bow_bench_locker_base_part();
    color([0.86, 0.87, 0.88])
        bow_bench_cushion_part();
    color([0.04, 0.05, 0.06])
        bow_railing_assembly_reference();
}
