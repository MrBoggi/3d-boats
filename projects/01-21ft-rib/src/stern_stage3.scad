include <config.scad>
use <outboard_adapter.scad>
use <../../../shared/components/servos/savox_sw0250mg.scad>

stern_station_x = [430, 540, 585, 592, 625, 645, 660];
stern_v_station_x = [430, 540, 585, 592];
stern_tube_z = [61, 62, 63, 64, 65, 68, 70];
stern_tube_diameter = [54, 54, 54, 54, 52, 36, 4];
stern_tube_y = reference_beam / 2 - reference_tube_diameter / 2;
// The V-plane first intersects the 54 mm pontoon near Y=82 mm.
// Extending it to Y=86 creates structural overlap without a separate strut.
stern_chine_half_width = 86;
stern_keel_z = 0;
stern_chine_z = tan(reference_deadrise) * stern_chine_half_width;
// The 18 mm watertight transom includes the former adapter thickness.
// The pontoons retain useful volume aft of the recessed transom and then taper to X=660.
stern_transom_aft_x = 592;
stern_transom_thickness = 18;
stern_blend_tube_z = [
    stern_tube_z[0],
    stern_tube_z[1],
    stern_tube_z[2],
    stern_tube_z[3]
];
stern_motor_mount_center_x =
    stern_transom_aft_x + mount0_mounting_face_offset;
stern_motor_body_aft_offset = 24.205;
stern_motor_body_lateral_offset = -1.226;
stern_mount0_pivot_local_x = 4.160;
stern_motor_pin_x = stern_motor_mount_center_x - 5.375;
stern_motor_pin_z = [
    mount_center_z - 10.253,
    mount_center_z + 8.740
];

function stern_mount_plate_x() = stern_transom_aft_x;
function stern_motor_mount_x() = stern_motor_mount_center_x;
function stern_motor_body_x() =
    stern_motor_mount_center_x + stern_motor_body_aft_offset;
function stern_motor_body_y() = stern_motor_body_lateral_offset;
function stern_mount0_pivot_x() = stern_mount0_pivot_local_x;
function stern_motor_pin_axis_x() = stern_motor_pin_x;
function stern_motor_pin_axis_z() = stern_motor_pin_z;
function stern_forward_tube_y() = stern_tube_y;
function stern_forward_tube_z() = stern_tube_z[0];
function stern_forward_tube_diameter() = stern_tube_diameter[0];
function stern_forward_chine_half_width() = stern_chine_half_width;
function stern_forward_chine_z() = stern_chine_z;
function stern_aft_tip_x() = stern_station_x[len(stern_station_x) - 1];

assert(stern_station_x[len(stern_station_x) - 1]
    - stern_station_x[0] <= printer_x,
    "Stern reference length exceeds Bambu A1 X capacity");
assert(reference_tube_diameter >= 50.8
    && reference_tube_diameter <= 57,
    "Tube diameter is outside researched 21 ft RIB range");
assert(stern_transom_thickness - mount0_insert_pocket_depth >= 5,
    "Mount insert pockets leave too little sealed transom material");
assert(stern_station_x[len(stern_station_x) - 1] > stern_transom_aft_x,
    "Only the pontoons must extend aft of the transom");
assert(!stern_mount_design_locked
    || (
        stern_transom_thickness == 18
        && abs(mount0_transom_tilt_correction + 5) < 0.001
        && abs(motor_mount_tilt_correction + 5) < 0.001
        && abs(mount0_mounting_face_offset - 7.366) < 0.001
        && abs(stern_motor_body_aft_offset - 24.205) < 0.001
        && abs(stern_motor_body_lateral_offset + 1.226) < 0.001
        && abs(stern_mount0_pivot_local_x - 4.160) < 0.001
        && abs(required_leg_extension - 28.4085) < 0.001
    ),
    "LOCKED stern motor interface changed; re-run alignment approval");

module stern_v_station(x, width = 2 * stern_chine_half_width,
        keel_z = stern_keel_z, chine_z = stern_chine_z,
        thickness = 1) {
    polyhedron(
        points = [
            [x - thickness / 2, -width / 2, chine_z],
            [x - thickness / 2, width / 2, chine_z],
            [x - thickness / 2, 0, keel_z],
            [x + thickness / 2, -width / 2, chine_z],
            [x + thickness / 2, width / 2, chine_z],
            [x + thickness / 2, 0, keel_z]
        ],
        faces = [
            [0, 2, 1], [3, 4, 5],
            [0, 1, 4, 3], [1, 2, 5, 4], [2, 0, 3, 5]
        ]);
}

module stern_v_outer() {
    for (i = [0 : len(stern_v_station_x) - 2])
        hull() {
            stern_v_station(stern_v_station_x[i]);
            stern_v_station(stern_v_station_x[i + 1]);
        }
}

module stern_v_shell() {
    difference() {
        stern_v_outer();
        for (i = [0 : len(stern_v_station_x) - 2])
            hull() {
                stern_v_station(stern_v_station_x[i],
                    width = 2 * stern_chine_half_width
                        - 2 * wall_thickness,
                    keel_z = stern_keel_z + wall_thickness * 1.8,
                    chine_z = stern_chine_z + 10);
                stern_v_station(stern_v_station_x[i + 1],
                    width = 2 * stern_chine_half_width
                        - 2 * wall_thickness,
                    keel_z = stern_keel_z + wall_thickness * 1.8,
                    chine_z = stern_chine_z + 10);
            }
    }
}

module stern_tube_station(i, radius_delta = 0) {
    radius = max(0.25,
        stern_tube_diameter[i] / 2 - radius_delta);
    translate([
        stern_station_x[i],
        stern_tube_y,
        stern_tube_z[i]
    ])
        rotate([0, 90, 0])
            cylinder(h = 1, r = radius, center = true);
}

module stern_tube_side(side, radius_delta = 0) {
    for (i = [0 : len(stern_station_x) - 2])
        hull() {
            scale([1, side, 1])
                stern_tube_station(i, radius_delta);
            scale([1, side, 1])
                stern_tube_station(i + 1, radius_delta);
        }
}

module stern_pontoon_shells() {
    union() {
        for (side = [-1, 1])
            difference() {
                stern_tube_side(side);
                stern_tube_side(side, wall_thickness);
            }

        // Closed exposed aft ends; forward ends remain open for the next section.
        for (side = [-1, 1])
            translate([
                stern_station_x[len(stern_station_x) - 1],
                side * stern_tube_y,
                stern_tube_z[len(stern_tube_z) - 1]
            ])
                rotate([0, 90, 0])
                    cylinder(h = wall_thickness,
                        d = stern_tube_diameter[
                            len(stern_tube_diameter) - 1],
                        center = true);
    }
}

// Flat-ended structural profile shared by every longitudinal hull section.
// The X-normal end face at 430 is the continuation datum for the mid hull.
module stern_pontoon_hull_saddle_station(x, side, tube_z) {
    contact_radius = reference_tube_diameter / 2 - 3;

    hull() {
        // Two contacts distributed along the V-shell.
        for (hull_y = [70, 80])
            translate([
                x,
                side * hull_y,
                tan(reference_deadrise) * hull_y
            ])
                rotate([0, 90, 0])
                    cylinder(h = 1,
                        r = pontoon_hull_saddle_radius,
                        center = true, $fn = 24);

        // Two contacts distributed over the lower-inner pontoon quadrant.
        for (contact_angle = [225, 250])
            translate([
                x,
                side * (stern_tube_y
                    + contact_radius * cos(contact_angle)),
                tube_z + contact_radius * sin(contact_angle)
            ])
                rotate([0, 90, 0])
                    cylinder(h = 1,
                        r = pontoon_hull_saddle_radius,
                        center = true, $fn = 24);
    }
}

module stern_pontoon_hull_saddles() {
    for (side = [-1, 1])
        for (i = [0 : len(stern_v_station_x) - 2])
            hull() {
                stern_pontoon_hull_saddle_station(
                    stern_v_station_x[i],
                    side,
                    stern_blend_tube_z[i]);
                stern_pontoon_hull_saddle_station(
                    stern_v_station_x[i + 1],
                    side,
                    stern_blend_tube_z[i + 1]);
            }
}

module stern_keel_spine() {
    translate([
        (stern_station_x[0]
            + stern_transom_aft_x) / 2,
        0,
        4
    ])
        cube([stern_transom_aft_x
            - stern_station_x[0], 10, 8], center = true);
}

// Sloped inner splashwell: a watertight continuation from the cockpit floor
// to the recessed transom, with broad side knees instead of a box wall.
module stern_splashwell_floor() {
    hull() {
        translate([570, 0, stern_chine_z + 1.5])
            cube([2, 126, 3], center = true);
        translate([
            stern_transom_aft_x - stern_transom_thickness - 1,
            0,
            stern_chine_z + 8
        ])
            cube([2, 118, 4], center = true);
    }
}

module stern_splashwell_side_knees() {
    for (side = [-1, 1])
        hull() {
            translate([570, side * 63, stern_chine_z + 5])
                cube([3, 8, 10], center = true);
            translate([
                stern_transom_aft_x - stern_transom_thickness - 1,
                side * 62,
                (stern_chine_z + reference_xl_transom_height) / 2
            ])
                cube([
                    3,
                    10,
                    reference_xl_transom_height - stern_chine_z
                ], center = true);
        }
}

module stern_steering_servo_pad() {
    flange_support_z = steering_servo_axis[2]
        - savox_sw0250_total_height()
        + savox_sw0250_flange_from_bottom()
        - savox_sw0250_flange_size()[2] / 2;
    floor_support_z = stern_chine_z + 3;
    boss_height = flange_support_z - floor_support_z;

    assert(boss_height
            > steering_servo_insert_pocket_depth + 4,
        "Servo insert boss is too short for a blind M2 pocket");

    difference() {
        union()
            for (hole_x = savox_sw0250_mount_hole_x())
                translate([
                    steering_servo_axis[0],
                    hole_x,
                    floor_support_z + boss_height / 2
                ])
                    cylinder(h = boss_height,
                        d = steering_servo_insert_boss_diameter,
                        center = true, $fn = 30);

        for (hole_x = savox_sw0250_mount_hole_x())
            translate([
                steering_servo_axis[0],
                hole_x,
                flange_support_z
                    - steering_servo_insert_pocket_depth / 2
                    + boolean_overlap
            ])
                cylinder(
                    h = steering_servo_insert_pocket_depth
                        + 2 * boolean_overlap,
                    d = steering_servo_insert_pocket_diameter,
                    center = true, $fn = 24);
    }
}

module stern_steering_servo_cup() {
    body = savox_sw0250_body_size();
    clearance_size = [
        body[1] + 2 * steering_servo_body_clearance,
        body[0] + 2 * steering_servo_body_clearance,
        9
    ];
    cup_wall = 2.8;
    cup_bottom_z = steering_servo_axis[2]
        - savox_sw0250_total_height() - 3;
    cup_top_z = stern_chine_z + 7;

    difference() {
        translate([
            steering_servo_axis[0],
            savox_sw0250_body_center_from_output(),
            (cup_bottom_z + cup_top_z) / 2
        ])
            cube([
                clearance_size[0] + 2 * cup_wall,
                clearance_size[1] + 2 * cup_wall,
                cup_top_z - cup_bottom_z
            ], center = true);

        translate([
            steering_servo_axis[0],
            savox_sw0250_body_center_from_output(),
            cup_bottom_z + 3
                + (cup_top_z - cup_bottom_z) / 2
        ])
            cube([
                clearance_size[0],
                clearance_size[1],
                cup_top_z - cup_bottom_z
            ], center = true);
    }
}

module stern_cockpit_transition() {
    servo_body_bottom_z = steering_servo_axis[2]
        - savox_sw0250_total_height();
    servo_clearance_top_z = stern_chine_z + 18;

    union() {
        difference() {
            union() {
                stern_splashwell_floor();
                stern_steering_servo_cup();
            }

            translate([
                steering_servo_axis[0],
                savox_sw0250_body_center_from_output(),
                (servo_body_bottom_z
                    + servo_clearance_top_z) / 2
            ])
                cube([
                    savox_sw0250_body_size()[1]
                        + 2 * steering_servo_body_clearance,
                    savox_sw0250_body_size()[0]
                        + 2 * steering_servo_body_clearance,
                    servo_clearance_top_z
                        - servo_body_bottom_z
                ], center = true);
        }
        stern_splashwell_side_knees();
        stern_steering_servo_pad();
    }
}
module stern_transom_core() {
    union() {
        stern_v_station(
            stern_transom_aft_x - stern_transom_thickness / 2,
            thickness = stern_transom_thickness);

        translate([
            stern_transom_aft_x - stern_transom_thickness / 2,
            0,
            (stern_chine_z + reference_xl_transom_height) / 2
        ])
            cube([
                stern_transom_thickness,
                2 * stern_chine_half_width,
                reference_xl_transom_height - stern_chine_z
            ], center = true);
    }
}

module stern_transom() {
    difference() {
        stern_transom_core();

        // Blind heat-set insert pockets, open only from the aft face.
        translate([
            stern_transom_aft_x
                - mount0_insert_pocket_depth / 2
                + boolean_overlap / 2,
            0,
            mount_center_z
        ]) {
            mount0_hole_pattern(
                hole_diameter = mount0_insert_pocket_diameter,
                length = mount0_insert_pocket_depth + boolean_overlap);

            // Blind recess for the Mount 0 centre boss.
            translate([
                (mount0_insert_pocket_depth
                    - mount0_boss_recess_depth) / 2,
                0,
                0
            ])
            rotate([0, 90, 0])
                cylinder(
                    h = mount0_boss_recess_depth + boolean_overlap,
                    d = mount0_center_clearance_diameter, center = true);
        }
    }
}

module stern_structure() {
    union() {
        stern_v_shell();
        stern_pontoon_hull_saddles();
        stern_pontoon_shells();
        stern_keel_spine();
        stern_cockpit_transition();
        stern_transom();
    }
}
