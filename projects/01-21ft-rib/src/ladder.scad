include <config.scad>

module ladder() {
    rail_spacing = 38;
    rail_diameter = 6;
    ladder_height = 112;

    for (y = [-rail_spacing / 2, rail_spacing / 2])
        translate([0, y, 0])
            cylinder(h = ladder_height, d = rail_diameter);

    for (z = [18, 48, 78, 108])
        translate([0, 0, z])
            rotate([90, 0, 0])
                cylinder(h = rail_spacing, d = 5, center = true);

    // Separate insertion pegs for the stern sockets.
    for (y = [-rail_spacing / 2, rail_spacing / 2])
        translate([-10, y, 7])
            rotate([0, 90, 0])
                cylinder(h = 20, d = 5);
}

module ladder_assembled() {
    translate([603, -54, 78])
        rotate([0, -28, 0])
            ladder();
}
