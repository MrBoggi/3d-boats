include <config.scad>

module rear_light_housing() {
    difference() {
        cube(rear_light_housing_size, center = true);
        translate([rear_light_housing_size[0] / 2, 0, 0])
            cube([
                rear_light_lens_size[0] + boolean_overlap,
                rear_light_lens_size[1] + 2 * fit_clearance,
                rear_light_lens_size[2] + 2 * fit_clearance
            ], center = true);
        for (z = [-rear_light_mount_spacing_z / 2,
                rear_light_mount_spacing_z / 2])
            translate([0, 0, z])
                rotate([0, 90, 0])
                    cylinder(h = rear_light_housing_size[0]
                            + 2 * boolean_overlap,
                        d = rear_accessory_hole_diameter, center = true);
        for (y = [-rear_light_lens_hole_spacing_y / 2,
                rear_light_lens_hole_spacing_y / 2])
            translate([0, y, 0])
                rotate([0, 90, 0])
                    cylinder(h = rear_light_housing_size[0]
                            + 2 * boolean_overlap,
                        d = rear_light_lens_pilot_hole, center = true);
    }
}

module rear_light_lens() {
    difference() {
        cube(rear_light_lens_size, center = true);
        for (y = [-rear_light_lens_hole_spacing_y / 2,
                rear_light_lens_hole_spacing_y / 2])
            translate([0, y, 0])
                rotate([0, 90, 0])
                    cylinder(h = rear_light_lens_size[0]
                            + 2 * boolean_overlap,
                        d = rear_light_lens_clearance_hole, center = true);
    }
}

module license_plate_holder() {
    difference() {
        cube(license_plate_size, center = true);
        for (y = [-license_plate_hole_spacing_y / 2,
                license_plate_hole_spacing_y / 2])
            translate([0, y, 0])
                rotate([0, 90, 0])
                    cylinder(h = license_plate_size[0]
                            + 2 * boolean_overlap,
                        d = rear_accessory_hole_diameter, center = true);
    }
}

module rear_accessories_assembly() {
    accessory_face_x = rear_accessory_x
        + crossmember_size[0] / 2;

    for (side = [-1, 1]) {
        translate([
            accessory_face_x + rear_light_housing_size[0] / 2,
            side * rear_light_y,
            frame_bottom_z + crossmember_size[2] / 2
        ])
            color([0.18, 0.18, 0.18]) rear_light_housing();
        translate([
            accessory_face_x + rear_light_housing_size[0]
                + rear_light_lens_size[0] / 2,
            side * rear_light_y,
            frame_bottom_z + crossmember_size[2] / 2
        ])
            color([0.85, 0.05, 0.03]) rear_light_lens();
    }

    translate([
        accessory_face_x + license_plate_size[0] / 2,
        license_plate_center_y,
        frame_bottom_z + crossmember_size[2] / 2
    ])
        color([0.82, 0.84, 0.86]) license_plate_holder();
}
