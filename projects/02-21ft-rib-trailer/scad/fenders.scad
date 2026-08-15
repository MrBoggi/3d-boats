include <config.scad>

module tandem_capsule(width, diameter) {
    hull()
        for (x = [-bogie_axle_spacing / 2,
                bogie_axle_spacing / 2])
            translate([x, 0, 0])
                rotate([90, 0, 0])
                    cylinder(h = width, d = diameter, center = true);
}

module tandem_fender_band(width, outer_diameter, inner_diameter) {
    difference() {
        tandem_capsule(width, outer_diameter);
        tandem_capsule(width + 2 * boolean_overlap, inner_diameter);
        translate([0, 0, -outer_diameter / 2])
            cube([
                bogie_axle_spacing + outer_diameter
                    + 2 * boolean_overlap,
                width + 4 * boolean_overlap,
                outer_diameter
            ], center = true);
    }
}

module tandem_fender(side = 1) {
    outer_diameter = wheel_diameter + 2 * fender_radial_clearance
        + 2 * fender_thickness;
    inner_diameter = wheel_diameter + 2 * fender_radial_clearance;
    back_y = -side * (fender_width / 2 - fender_thickness / 2);

    difference() {
        union() {
            tandem_fender_band(
                fender_width, outer_diameter, inner_diameter);
            translate([0, back_y, 0])
                tandem_fender_band(
                    fender_thickness + boolean_overlap,
                    outer_diameter, inner_diameter);
        }
        translate([0, back_y, fender_mount_hole_local_z])
            rotate([90, 0, 0])
                cylinder(h = fender_thickness + 4 * boolean_overlap,
                    d = fender_mount_hole_diameter, center = true);
    }
}

module fender_mount_bracket(side = 1) {
    bracket_length = fender_bracket_size[1];
    flange_y = side * (bracket_length / 2
        - fender_bracket_flange_thickness / 2);
    difference() {
        union() {
            cube(fender_bracket_size, center = true);
            translate([0, flange_y, fender_bracket_flange_height / 2])
                cube([fender_bracket_size[0],
                    fender_bracket_flange_thickness,
                    fender_bracket_flange_height], center = true);
        }
        translate([0, side * (fender_bracket_rail_hole_y
                - fender_bracket_center_y), 0])
            cylinder(h = fender_bracket_size[2]
                    + 2 * boolean_overlap,
                d = fender_mount_hole_diameter, center = true);
        translate([0, flange_y, fender_bracket_hole_local_z])
            rotate([90, 0, 0])
                cylinder(h = fender_bracket_flange_thickness
                        + 2 * boolean_overlap,
                    d = fender_mount_hole_diameter, center = true);
    }
}

module fender_assembly(side = 1) {
    color([0.20, 0.21, 0.23])
        translate([bogie_center_x, side * fender_center_y, wheel_axis_z])
            tandem_fender(side);
    color([0.48, 0.50, 0.53])
        translate([bogie_center_x,
                side * fender_bracket_center_y,
                fender_bracket_z])
            fender_mount_bracket(side);
}
