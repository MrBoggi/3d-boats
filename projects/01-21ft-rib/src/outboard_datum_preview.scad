include <config.scad>
use <../../../shared/components/outboards/printables_1191848.scad>

// Step 1 only: verify motor datums before any hull redesign.
show_exploded_mounts = true;
motor_orientation = [0, 0, -90];

// Derived from the native STL coordinate system, in millimetres.
steering_axis_xy = [0, 0];
propeller_axis_z = -55;
cavitation_reference_z = -28;

module datum_arrow(axis = "x", length = 120, diameter = 2.5) {
    if (axis == "x")
        rotate([0, 90, 0]) cylinder(h = length, d = diameter);
    else if (axis == "y")
        rotate([-90, 0, 0]) cylinder(h = length, d = diameter);
    else
        cylinder(h = length, d = diameter);
}

module datum_label(value, position, rotation = [90, 0, 0], size = 7) {
    color([0.05, 0.05, 0.05])
        translate(position)
            rotate(rotation)
                linear_extrude(height = 0.6)
                    text(value, size = size, halign = "center");
}

module oriented_motor_reference() {
    rotate(motor_orientation)
        outboard_1191848_reference();
}

module motor_datums() {
    // Boat coordinates: X forward, Y starboard, Z up.
    color("red") datum_arrow("x", 125);
    color("green") datum_arrow("y", 90);
    color("blue") datum_arrow("z", 115);

    // Proposed steering axis through the housing centre.
    color([0.8, 0.1, 0.8, 0.8])
        translate([steering_axis_xy[0], steering_axis_xy[1], -90])
            cylinder(h = 190, d = 2);

    // Propeller shaft datum, parallel to boat X.
    color([0.1, 0.8, 0.9, 0.9])
        translate([-75, 0, propeller_axis_z])
            rotate([0, 90, 0])
                cylinder(h = 150, d = 3);

    // Anticavitation reference plane, to be aligned near the hull bottom.
    color([0.2, 0.55, 1, 0.22])
        translate([0, 0, cavitation_reference_z])
            cube([145, 90, 1], center = true);

    datum_label("X FORWARD", [112, 0, 3]);
    datum_label("PROP AXIS", [62, 0, propeller_axis_z + 4]);
    datum_label("CAVITATION", [0, 42, cavitation_reference_z + 2]);
}

module exploded_mounts() {
    if (show_exploded_mounts) {
        color([0.85, 0.55, 0.12])
            translate([0, -105, 0])
                rotate(motor_orientation)
                    outboard_1191848_mount_reference(0);
        color([0.95, 0.72, 0.2])
            translate([0, 105, 0])
                rotate(motor_orientation)
                    outboard_1191848_mount_reference(-3);
        datum_label("MOUNT 0 - EXPLODED", [0, -105, -28]);
        datum_label("MOUNT -3 - EXPLODED", [0, 105, -28]);
    }
}

color([0.92, 0.78, 0.12])
    oriented_motor_reference();
motor_datums();
exploded_mounts();
