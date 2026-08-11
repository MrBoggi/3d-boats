include <config.scad>
use <stern_stage3.scad>
use <outboard_xl_extension.scad>
use <outboard_adapter.scad>

show_motor = true;
show_mount_axes = false;
show_motor_pins = false;
show_steering_pin = false;

color([0.12, 0.14, 0.17]) {
    stern_v_shell();
    stern_pontoon_hull_saddles();
    stern_keel_spine();
    stern_cockpit_transition();
    stern_transom();
}

color([0.98, 0.62, 0.02])
    stern_pontoon_shells();

if (show_motor) {
    translate([stern_motor_mount_x(), 0, 0])
        color([0.95, 0.35, 0.08])
            positioned_mount0();

    translate([stern_motor_body_x(), stern_motor_body_y(), 0]) {
        color([0.90, 0.76, 0.12])
            positioned_vendor_upper();

        color([0.88, 0.68, 0.10])
            positioned_xl_extension();

        color([0.88, 0.68, 0.10])
            positioned_vendor_lower(required_leg_extension);
    }
}

if (show_mount_axes)
    color([0.9, 0.1, 0.2, 0.8])
        translate([
            stern_mount_plate_x(),
            0,
            mount_center_z
        ])
            mount0_hole_pattern(
                hole_diameter = 1.2,
                length = 45);

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
