include <config.scad>

module drivetrain_reference() {
    color([0.7, 0.7, 0.72])
        translate([585, 0, 24])
            rotate([0, 90 - shaft_angle, 0])
                cylinder(h = 145, d = 8, center = true);
    color([0.85, 0.65, 0.15])
        translate([648, 0, 12])
            rotate([0, 90 - shaft_angle, 0])
                cylinder(h = 12, d = 34, center = true);
}
