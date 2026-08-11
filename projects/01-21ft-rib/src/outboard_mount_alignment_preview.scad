include <config.scad>
use <stern_stage3.scad>
use <outboard_xl_extension.scad>
use <outboard_adapter.scad>

show_transom = true;
show_motor_shell = true;
show_axes = true;
show_motor_pins = false;
show_steering_pin = true;

if (show_transom)
    color([0.12, 0.14, 0.17, 0.45])
        stern_transom();

translate([stern_motor_body_x(), stern_motor_body_y(), 0])
    if (show_motor_shell)
        color([0.90, 0.76, 0.12, 0.38])
            positioned_vendor_upper();

translate([stern_motor_mount_x(), 0, 0])
    color([0.95, 0.35, 0.08])
        positioned_mount0();

if (show_axes) {
    color([0.9, 0.05, 0.05])
        translate([
            stern_mount_plate_x(),
            0,
            mount_center_z
        ])
            mount0_hole_pattern(
                hole_diameter = 1.2,
                length = 50);

}

if (show_motor_pins)
    color([0.05, 0.80, 0.25, 0.9])
        for (pin_z = stern_motor_pin_axis_z())
            translate([
                stern_motor_pin_axis_x(),
                0,
                pin_z
            ])
                rotate([90, 0, 0])
                    cylinder(h = 100, d = 2.4, center = true);

if (show_steering_pin)
    color([0.05, 0.65, 0.95, 0.95])
        translate([
            stern_motor_mount_x(),
            0,
            mount_center_z
        ])
            rotate([0, mount0_transom_tilt_correction, 0])
                translate([stern_mount0_pivot_x(), 0, 0])
                    cylinder(h = 80, d = 2.4, center = true);
