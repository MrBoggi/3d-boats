include <config.scad>
use <stern_stage3.scad>
use <outboard_xl_extension.scad>
use <outboard_adapter.scad>
use <../../../shared/components/servos/savox_sw0250mg.scad>

steering_test_angle = 0; // Inspect -30, 0 and +30 degrees.

function rotate_xy(point, centre, angle) = [
    centre[0]
        + (point[0] - centre[0]) * cos(angle)
        - (point[1] - centre[1]) * sin(angle),
    centre[1]
        + (point[0] - centre[0]) * sin(angle)
        + (point[1] - centre[1]) * cos(angle),
    point[2]
];

steering_pivot = [
    stern_motor_mount_x()
        + stern_mount0_pivot_x()
            * cos(mount0_transom_tilt_correction),
    0,
    motor_steering_bolt_z
];

servo_neutral_pin = [
    steering_servo_axis[0],
    -steering_arm_radius,
    steering_servo_axis[2]
];

motor_neutral_pin = [
    steering_pivot[0],
    -steering_arm_radius,
    steering_pivot[2]
];

servo_pin = rotate_xy(
    servo_neutral_pin,
    steering_servo_axis,
    steering_test_angle);
motor_pin = rotate_xy(
    motor_neutral_pin,
    steering_pivot,
    steering_test_angle);

module rod_between(a, b, diameter = 2) {
    hull() {
        translate(a) sphere(d = diameter, $fn = 20);
        translate(b) sphere(d = diameter, $fn = 20);
    }
}

// Printed stern structure and locked vendor outboard reference.
color([0.12, 0.14, 0.17])
    stern_structure();

translate([stern_motor_mount_x(), 0, 0])
    color([0.95, 0.35, 0.08])
        positioned_mount0();

translate([stern_motor_body_x(), stern_motor_body_y(), 0]) {
    color([0.90, 0.76, 0.12, 0.55])
        positioned_vendor_upper();
    color([0.88, 0.68, 0.10, 0.55])
        positioned_xl_extension();
    color([0.88, 0.68, 0.10, 0.55])
        positioned_vendor_lower(required_leg_extension);
}

// Dimensioned Savox body, flange, two screw holes and offset spline.
translate(steering_servo_axis)
    rotate([0, 0, steering_servo_rotation_z])
        savox_sw0250mg_reference();

color([0.05, 0.65, 0.95])
    translate(steering_servo_axis)
        cylinder(h = 5, d = 3, center = true);

// Equal 18 mm arms connect the servo to the port end of the steering bolt.
color([0.10, 0.80, 0.25]) {
    rod_between(steering_servo_axis, servo_pin, 2.5);
    rod_between(servo_pin, motor_pin, 2);
}

// Through-bolt in the motor steering hole with a port-side ball stud.
motor_opposite_pin = rotate_xy([
        steering_pivot[0],
        steering_arm_radius,
        motor_steering_bolt_z
    ], steering_pivot, steering_test_angle);

color([0.90, 0.10, 0.65]) {
    rod_between(motor_opposite_pin, motor_pin,
        motor_steering_bolt_diameter);
    translate(motor_pin) sphere(d = 5, $fn = 24);
}

echo("STEERING_TEST_ANGLE_DEG", steering_test_angle);
echo("STEERING_ROD_LENGTH_MM", norm(motor_pin - servo_pin));
echo("MINISERVO_ENVELOPE_MM", servo_envelope);
echo("SERVO_MOUNT_HOLE_SPACING_MM", savox_sw0250_hole_spacing());

assert(abs(norm(motor_pin - servo_pin)
        - norm(motor_neutral_pin - servo_neutral_pin)) < 0.01,
    "Parallel steering linkage changes rod length");
assert(steering_servo_axis[2] - steering_linkage_clearance
        > reference_xl_transom_height,
    "Steering linkage does not clear the transom top");
assert(abs(2 * steering_arm_radius - motor_steering_bolt_length)
        < 0.001,
    "Motor steering bolt length does not match the linkage-arm radius");
