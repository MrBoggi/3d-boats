include <config.scad>
use <stern_stage3.scad>
use <../../../shared/components/servos/savox_sw0250mg.scad>

servo_explode_z = 8;
flange_support_z = steering_servo_axis[2]
    - savox_sw0250_total_height()
    + savox_sw0250_flange_from_bottom()
    - savox_sw0250_flange_size()[2] / 2;

color([0.12, 0.14, 0.17])
    stern_cockpit_transition();

translate([0, 0, servo_explode_z])
    translate(steering_servo_axis)
        rotate([0, 0, steering_servo_rotation_z])
            savox_sw0250mg_reference();

// Brass insert references in the two blind boss pockets.
color([0.85, 0.58, 0.12])
    for (hole_x = savox_sw0250_mount_hole_x())
        translate([
            steering_servo_axis[0],
            hole_x,
            flange_support_z
                - steering_servo_insert_pocket_depth / 2
        ])
            cylinder(h = 3,
                d = steering_servo_insert_pocket_diameter,
                center = true, $fn = 30);

// M2 screw axes; actual screws install vertically from above.
color([0.85, 0.12, 0.16, 0.85])
    for (hole_x = savox_sw0250_mount_hole_x())
        translate([
            steering_servo_axis[0],
            hole_x,
            flange_support_z + 6
        ])
            cylinder(h = 16, d = 1.2, center = true, $fn = 20);

echo("SAVOX_MOUNT_HOLE_SPACING_MM", savox_sw0250_hole_spacing());
echo("M2_INSERT_POCKET_MM", [
    steering_servo_insert_pocket_diameter,
    steering_servo_insert_pocket_depth
]);
