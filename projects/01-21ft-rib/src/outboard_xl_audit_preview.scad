include <config.scad>
use <../../../shared/components/outboards/printables_1191848.scad>

// Dimensional audit against a 6.5-6.6 m RIB at 1:10.

module x_axis(length, diameter = 1.5) {
    rotate([0, 90, 0])
        cylinder(h = length, d = diameter, center = true);
}

module reference_tubes() {
    tube_y = reference_beam / 2 - reference_tube_diameter / 2;
    color([0.98, 0.62, 0.02, 0.35])
        for (side = [-1, 1])
            translate([0, side * tube_y, reference_tube_center_z])
                rotate([0, 90, 0])
                    cylinder(h = 14, d = reference_tube_diameter,
                        center = true);
}

module reference_v_transom() {
    chine_half_width = 72;
    chine_z = tan(reference_deadrise) * chine_half_width;
    color([0.12, 0.14, 0.17, 0.30])
        polyhedron(
            points = [
                [-3, -chine_half_width, chine_z],
                [-3, chine_half_width, chine_z],
                [-3, 0, 0],
                [3, -chine_half_width, chine_z],
                [3, chine_half_width, chine_z],
                [3, 0, 0]
            ],
            faces = [
                [0, 2, 1], [3, 4, 5],
                [0, 1, 4, 3], [1, 2, 5, 4], [2, 0, 3, 5]
            ]);
}

module aligned_vendor_motor() {
    color([0.90, 0.76, 0.12])
        translate([0, 0, mount_center_z + assembly_origin_above_mount])
            rotate([0, 0, -90])
                outboard_1191848_reference();

    color([0.85, 0.50, 0.08])
        translate([0, 0, mount_center_z])
            rotate([0, 0, -90])
                outboard_1191848_mount_reference(0);
}

module datum_planes() {
    current_cavitation_z =
        mount_center_z - mount_center_to_cavitation;
    current_propeller_z =
        mount_center_z - mount_center_to_propeller;

    color([0.15, 0.55, 1, 0.35])
        translate([0, 0, current_cavitation_z])
            cube([115, 245, 1], center = true);

    color([0.1, 0.8, 0.3, 0.50])
        translate([0, 0, target_cavitation_z])
            cube([115, 245, 1], center = true);

    color([0.1, 0.8, 0.9])
        translate([0, 0, current_propeller_z])
            x_axis(125, 2.5);

    color([0.9, 0.1, 0.2])
        translate([0, 0, target_cavitation_z])
            cylinder(h = required_leg_extension, d = 3);
}

echo("REFERENCE_TUBE_DIAMETER_MM", reference_tube_diameter);
echo("REFERENCE_DEADRISE_DEG", reference_deadrise);
echo("MOUNT_CENTER_Z_MM", mount_center_z);
echo("CURRENT_CAVITATION_Z_MM",
    mount_center_z - mount_center_to_cavitation);
echo("TARGET_CAVITATION_Z_MM", target_cavitation_z);
echo("REQUIRED_LEG_EXTENSION_MM", required_leg_extension);

reference_tubes();
reference_v_transom();
aligned_vendor_motor();
datum_planes();
