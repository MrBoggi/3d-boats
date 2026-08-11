include <config.scad>

module envelope(size, label = "") {
    color([0.15, 0.55, 0.95, 0.45])
        cube(size, center = true);
    if (label != "")
        echo(str(label, " clearance envelope: ", size));
}

module hardware_envelopes() {
    translate([305, 0, 58]) envelope(battery_envelope, "battery");
    translate([500, 0, 58]) rotate([0, 0, 90])
        envelope(motor_envelope, "motor");
    translate([490, -55, 62]) envelope(esc_envelope, "ESC");
    translate([560, 55, 63]) envelope(servo_envelope, "servo");
    translate([405, -52, 62]) envelope(receiver_envelope, "receiver");
    translate([410, 52, 57]) envelope(ubec_envelope, "UBEC");
}

module slotted_tray(size, strap_slots = true) {
    difference() {
        cube([size[0], size[1], 3], center = true);
        if (strap_slots)
            for (x = [-size[0] / 3, size[0] / 3])
                translate([x, 0, 0])
                    cube([5, size[1] - 8, 5], center = true);
    }
    for (y = [-size[1] / 2, size[1] / 2])
        translate([0, y, 4])
            cube([size[0], 2.5, 8], center = true);
}

module equipment_mounts() {
    translate([305, 0, 39]) slotted_tray([155, 55, 3]);
    translate([490, -55, 42]) slotted_tray([85, 55, 3]);
    translate([560, 55, 42]) slotted_tray([48, 28, 3]);
    translate([405, -52, 42]) slotted_tray([60, 40, 3]);

    // Adjustable 2845 motor rails.
    for (y = [-19, 19])
        translate([500, y, 43])
            difference() {
                cube([72, 5, 10], center = true);
                for (x = [-22, 22])
                    translate([x, 0, 0])
                        cube([16, 7, 4], center = true);
            }
}
