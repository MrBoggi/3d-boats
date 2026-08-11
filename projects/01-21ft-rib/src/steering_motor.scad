include <config.scad>

pivot_diameter = 8;
pivot_clearance = 0.3;

module motor_cowl() {
    hull() {
        translate([0, 0, 31]) scale([1.15, 0.82, 0.70]) sphere(d = 58);
        translate([5, 0, 45]) scale([1.0, 0.78, 0.55]) sphere(d = 54);
    }
}

module steering_leg() {
    hull() {
        translate([0, 0, 2]) cube([16, 18, 48], center = true);
        translate([-7, 0, -52]) cube([10, 13, 66], center = true);
    }
    hull() {
        translate([-6, 0, -66]) cube([8, 12, 28], center = true);
        translate([-24, 0, -55]) cube([5, 9, 34], center = true);
    }
}

module steering_motor() {
    difference() {
        union() {
            motor_cowl();
            steering_leg();
            translate([-20, 0, 15])
                cylinder(h = 82, d = 15, center = true);
            translate([-20, 0, 53])
                cube([30, 8, 6], center = true);
        }
        translate([-20, 0, 15])
            cylinder(h = 86, d = pivot_diameter + pivot_clearance, center = true);
    }
}

module motor_bracket() {
    difference() {
        union() {
            translate([-8, 0, 34]) cube([16, 72, 12], center = true);
            for (z = [2, 66])
                hull() {
                    translate([-8, 0, z]) cube([16, 72, 8], center = true);
                    translate([12, 0, z])
                        cylinder(h = 8, d = 18, center = true);
                }
        }
        for (z = [2, 66])
            translate([12, 0, z])
                cylinder(h = 12,
                    d = pivot_diameter + pivot_clearance, center = true);
        for (y = [-25, 25])
            translate([-8, y, 34])
                rotate([0, 90, 0])
                    cylinder(h = 22, d = 3.3, center = true);
    }
}

module steering_motor_assembled(angle = 0) {
    translate([660, 0, 60]) {
        translate([-32, 0, -18]) motor_bracket();
        rotate([0, 0, angle]) steering_motor();
    }
}
