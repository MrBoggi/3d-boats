include <config.scad>

module rounded_box(size, radius = 5) {
    hull()
        for (x = [-size[0] / 2 + radius, size[0] / 2 - radius])
            for (y = [-size[1] / 2 + radius, size[1] / 2 - radius])
                translate([x, y, 0])
                    cylinder(h = size[2], r = radius);
}

module seat_unit(size) {
    color([0.34, 0.35, 0.37])
        rounded_box([size[0], size[1], size[2] - 5], 8);
    color([0.66, 0.67, 0.69])
        translate([0, 0, size[2] - 5 - boolean_overlap])
            rounded_box([size[0] - 4, size[1] - 4,
                5 + boolean_overlap], 7);
}

module gasketed_lid(size, ridge_size) {
    color([0.18, 0.20, 0.22])
        translate([0, 0, -boolean_overlap])
            rounded_box([size[0], size[1], 3 + boolean_overlap], 6);
    translate([0, 0, -2.5])
        difference() {
            cube([ridge_size[0], ridge_size[1], 5], center = true);
            cube([ridge_size[0] - 5, ridge_size[1] - 5,
                5 + 2 * boolean_overlap], center = true);
        }
}

module console_shape() {
    color([0.48, 0.49, 0.51])
        union() {
            hull() {
                translate([-24, 0, 5])
                    cube([18, 70, 10], center = true);
                translate([18, 0, 49])
                    cube([24, 60, 12], center = true);
            }
            translate([24, 0, 55])
                rotate([0, -15, 0])
                    cube([23, 64, 8], center = true);
        }
}

module console_helm() {
    union() {
        translate([315, 0, hull_deck_z + 11])
            gasketed_lid([178, 142], [157.5, 125]);
        translate([280, 0, hull_deck_z + 14])
            console_shape();
        translate([360, 0, hull_deck_z + 14])
            seat_unit([66, 82, 27]);
    }
}

module aft_bench() {
    union() {
        translate([515, 0, hull_deck_z + 11])
            gasketed_lid([178, 142], [167.5, 125]);
        translate([515, 0, hull_deck_z + 14])
            seat_unit([82, 110, 29]);
    }
}

module bow_bench() {
    color([0.44, 0.45, 0.47])
        translate([128, 0, hull_deck_z + 4])
            seat_unit([88, 108, 25]);
}

module windshield_frame() {
    translate([310, 0, hull_deck_z + 78])
        rotate([0, -15, 0])
            difference() {
                cube([5, 76, 40], center = true);
                cube([7, 61, 27], center = true);
            }
}

module superstructure_preview() {
    console_helm();
    aft_bench();
}
