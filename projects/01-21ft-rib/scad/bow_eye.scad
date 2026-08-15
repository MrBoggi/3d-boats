// Mounted bow-eye system for the 1:10 RIB. Dimensions in mm.

bow_eye_x = 42;
bow_eye_keel_z = 59.55;
bow_eye_ring_outer_diameter = 10;
bow_eye_ring_inner_diameter = 5;
bow_eye_ring_width = 3;
bow_eye_saddle_size = [14, 16, 2.4];
bow_eye_backing_size = [14, 14, 2.4];
bow_eye_bolt_spacing_x = 7;
bow_eye_bolt_hole = 2.2;
bow_eye_bolt_length = 12;
bow_eye_saddle_deadrise = 26;

module bow_eye_v_plate(size) {
    for (side = [-1, 1])
        translate([0, side * size[1] / 4, 0])
            rotate([side * bow_eye_saddle_deadrise, 0, 0])
                cube([size[0], size[1] / 2 + 0.4, size[2]], center = true);
}

module bow_eye_hull_cutters() {
    for (dx = [-bow_eye_bolt_spacing_x / 2, bow_eye_bolt_spacing_x / 2])
        translate([bow_eye_x + dx, 0, bow_eye_keel_z + 3])
            cylinder(h = 16, d = bow_eye_bolt_hole, center = true, $fn = 24);
}

module bow_eye_part() {
    difference() {
        union() {
            translate([0, 0, bow_eye_ring_outer_diameter / 2 + 1])
                bow_eye_v_plate(bow_eye_saddle_size);
            rotate([90, 0, 0])
                cylinder(h = bow_eye_ring_width,
                    d = bow_eye_ring_outer_diameter, center = true, $fn = 48);
        }
        rotate([90, 0, 0])
            cylinder(h = bow_eye_ring_width + 0.4,
                d = bow_eye_ring_inner_diameter, center = true, $fn = 36);
        for (dx = [-bow_eye_bolt_spacing_x / 2, bow_eye_bolt_spacing_x / 2])
            translate([dx, 0, bow_eye_ring_outer_diameter / 2 + 1])
                cylinder(h = 10, d = bow_eye_bolt_hole, center = true, $fn = 24);
    }
}

module bow_eye_backing_part() {
    difference() {
        bow_eye_v_plate(bow_eye_backing_size);
        for (dx = [-bow_eye_bolt_spacing_x / 2, bow_eye_bolt_spacing_x / 2])
            translate([dx, 0, 0])
                cylinder(h = 10, d = bow_eye_bolt_hole, center = true, $fn = 24);
    }
}

module bow_eye_fasteners() {
    color([0.72, 0.72, 0.76])
        for (dx = [-bow_eye_bolt_spacing_x / 2, bow_eye_bolt_spacing_x / 2])
            translate([bow_eye_x + dx, 0, bow_eye_keel_z + 2])
                cylinder(h = bow_eye_bolt_length, d = 2, center = true, $fn = 24);
}

module bow_eye_assembly(center = [bow_eye_x, 0,
        bow_eye_keel_z - (bow_eye_ring_outer_diameter / 2 + 1)]) {
    color([0.72, 0.72, 0.76]) translate(center) bow_eye_part();
    color([0.62, 0.64, 0.67])
        translate([bow_eye_x, 0, bow_eye_keel_z + 5.6])
            bow_eye_backing_part();
    bow_eye_fasteners();
}
