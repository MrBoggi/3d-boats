include <config.scad>

module shaft_support() {
    difference() {
        union() {
            translate([0, 0, 18])
                rotate([0, 90 - shaft_angle, 0])
                    cylinder(h = 22, d = 16, center = true);
            hull() {
                translate([0, 0, 14]) cube([12, 16, 5], center = true);
                translate([-18, 0, 0]) cube([24, 22, 4], center = true);
            }
        }
        translate([0, 0, 18])
            rotate([0, 90 - shaft_angle, 0])
                cylinder(h = 28,
                    d = shaft_tube_diameter + fastener_clearance,
                    center = true);
        for (y = [-7, 7])
            translate([-20, y, 0])
                cylinder(h = 8, d = 3.3, center = true);
    }
}

module shaft_support_assembled() {
    translate([610, 0, 12]) shaft_support();
}
