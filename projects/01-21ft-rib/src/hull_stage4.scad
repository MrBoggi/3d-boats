include <config.scad>
use <stern_stage3.scad>

// Bow-to-stern coordinate stations. The pontoon stations are calibrated from
// normalized plan-view widths in the supplied Zodiac reference. the first station sits 20 mm aft of X=0,
// allowing its spherical sweep to form a rounded capsule nose without changing the 660 mm hull datum. The final station is an exact copy of the
// approved stern interface at X=430.
stage4_v_bow_setback = 22;
stage4_x = [
    stage4_v_bow_setback, 32, 45, 60, 80, 105, 135,
    170, 220, 275, 335, 390, 430
];
// The outer half-width stays nearly constant aft of X=220 and then tightens
// monotonically towards the bow. Decreasing segment slopes towards the stern
// prevent the reverse S-curve present in the rejected version.
stage4_tube_x = [20, 50, 80, 115, 160, 230, 335, 430];
stage4_tube_y = [36, 53, 67, 81, 92, 97, 99, 99];
// The 31 mm centreline rise from the approved aft datum corresponds to
// approximately 310 mm at full scale and reproduces the strong bow sheer.
stage4_tube_z = [92, 89, 84, 78, 71, 65, 62, 61];
stage4_tube_diameter = [40, 44, 50, 54, 54, 54, 54, 54];
// The forward V is widened until its chine reaches the pontoon attachment
// zone. The final two values retain the approved stern interface.
stage4_v_half_width = [
    3, 10, 24, 32, 42, 52, 62,
    70, 78, 82, 86, 86, 86
];
// The chine follows the rising lower-inner pontoon quadrant. At X=22 it
// overlaps the locked bow tube, so the V-shape terminates inside the pontoon
// instead of below it on a flat triangular face.
stage4_chine_z = [
    73, 72, 69, 66, 61, 56, 51,
    47, 44, 43, 42, 42,
    stern_forward_chine_z()
];
stage4_keel_z = [
    for (i = [0 : len(stage4_x) - 1])
        stage4_chine_z[i]
            - tan(reference_deadrise) * stage4_v_half_width[i]
];

function stage4_v_segment_at(x, i = 0) =
    i >= len(stage4_x) - 2 ? len(stage4_x) - 2 :
    x <= stage4_x[i + 1] ? i :
    stage4_v_segment_at(x, i + 1);

function stage4_v_value_at(x, values) =
    x <= stage4_x[0] ? values[0] :
    x >= stage4_x[len(stage4_x) - 1]
        ? values[len(values) - 1] :
    let(
        i = stage4_v_segment_at(x),
        span = stage4_x[i + 1] - stage4_x[i],
        blend = (x - stage4_x[i]) / span
    )
    values[i] + (values[i + 1] - values[i]) * blend;

function stage4_v_surface_z_at(x, y) =
    stage4_v_value_at(x, stage4_keel_z)
        + tan(reference_deadrise) * abs(y);

assert(stage4_x[len(stage4_x) - 1] == section_mid_end,
    "Stage 4 forward loft must end at the stern section datum");
assert(len(stage4_x) == len(stage4_v_half_width)
        && len(stage4_x) == len(stage4_chine_z)
        && len(stage4_x) == len(stage4_keel_z),
    "Stage 4 V-bottom station arrays must have matching lengths");
assert(stage4_v_bow_setback > 0
        && stage4_v_bow_setback <= stage4_tube_diameter[3] / 2,
    "V-stem setback must terminate inside the rounded pontoon nose");
assert(stage4_tube_x[len(stage4_tube_x) - 1] == section_mid_end,
    "Stage 4 tube sweep must end at the stern section datum");
assert(stage4_tube_y[len(stage4_tube_y) - 1]
        == stern_forward_tube_y(),
    "Stage 4 tube Y does not match the approved stern");
assert(stage4_tube_z[len(stage4_tube_z) - 1]
        == stern_forward_tube_z(),
    "Stage 4 tube Z does not match the approved stern");
assert(stage4_tube_diameter[len(stage4_tube_diameter) - 1]
        == stern_forward_tube_diameter(),
    "Stage 4 tube diameter does not match the approved stern");
assert(stage4_v_half_width[len(stage4_v_half_width) - 1]
        == stern_forward_chine_half_width(),
    "Stage 4 V-bottom width does not match the approved stern");
assert(abs(stage4_chine_z[len(stage4_chine_z) - 1]
        - stern_forward_chine_z()) < 0.001,
    "Stage 4 deadrise does not match the approved stern");

module stage4_v_station(i, inset = 0,
        raised_keel = 0, raised_chine = 0) {
    half_width = max(0.8, stage4_v_half_width[i] - inset);
    x = stage4_x[i];
    keel_z = stage4_keel_z[i] + raised_keel;
    chine_z = stage4_chine_z[i] + raised_chine;

    polyhedron(
        points = [
            [x - 0.5, -half_width, chine_z],
            [x - 0.5, half_width, chine_z],
            [x - 0.5, 0, keel_z],
            [x + 0.5, -half_width, chine_z],
            [x + 0.5, half_width, chine_z],
            [x + 0.5, 0, keel_z]
        ],
        faces = [
            [0, 2, 1], [3, 4, 5],
            [0, 1, 4, 3], [1, 2, 5, 4], [2, 0, 3, 5]
        ], convexity = 4);
}

module stage4_v_outer() {
    for (i = [0 : len(stage4_x) - 2])
        hull() {
            stage4_v_station(i);
            stage4_v_station(i + 1);
        }
}

module stage4_v_shell() {
    difference() {
        stage4_v_outer();
        for (i = [0 : len(stage4_x) - 2])
            hull() {
                stage4_v_station(i,
                    inset = wall_thickness,
                    raised_keel = wall_thickness * 1.8,
                    raised_chine = 10);
                stage4_v_station(i + 1,
                    inset = wall_thickness,
                    raised_keel = wall_thickness * 1.8,
                    raised_chine = 10);
            }
    }
}

module stage4_tube_station(i, side, radius_delta = 0) {
    radius = max(0.25,
        stage4_tube_diameter[i] / 2 - radius_delta);
    translate([
        stage4_tube_x[i],
        side * stage4_tube_y[i],
        stage4_tube_z[i]
    ])
        sphere(r = radius);
}

module stage4_tube_side(side, radius_delta = 0) {
    for (i = [0 : len(stage4_tube_x) - 2])
        hull() {
            stage4_tube_station(i, side, radius_delta);
            stage4_tube_station(i + 1, side, radius_delta);
        }
}

function stage4_tube_segment_at(x, i = 0) =
    i >= len(stage4_tube_x) - 2 ? len(stage4_tube_x) - 2 :
    x <= stage4_tube_x[i + 1] ? i :
    stage4_tube_segment_at(x, i + 1);

function stage4_tube_value_at(x, values) =
    let(
        i = stage4_tube_segment_at(x),
        span = stage4_tube_x[i + 1] - stage4_tube_x[i],
        blend = (x - stage4_tube_x[i]) / span
    )
    values[i] + (values[i + 1] - values[i]) * blend;

module stage4_bow_bridge(radius_delta = 0) {
    radius = max(0.25, stage4_tube_diameter[0] / 2 - radius_delta);
    hull()
        for (side = [-1, 1])
            translate([
                stage4_tube_x[0],
                side * stage4_tube_y[0],
                stage4_tube_z[0]
            ])
                sphere(r = radius);
}

module stage4_pontoon_shells() {
    intersection() {
        difference() {
            union() {
                for (side = [-1, 1])
                    stage4_tube_side(side);
                stage4_bow_bridge();
            }
            union() {
                for (side = [-1, 1])
                    stage4_tube_side(side, wall_thickness);
                stage4_bow_bridge(wall_thickness);
            }
        }

        translate([section_mid_end / 2, 0, 70])
            cube([
                section_mid_end + boolean_overlap,
                printer_y,
                150
            ], center = true);
    }
}

module stage4_saddle_station(i, side) {
    station_x = stage4_x[i];
    tube_y = stage4_tube_value_at(station_x, stage4_tube_y);
    tube_z = stage4_tube_value_at(station_x, stage4_tube_z);
    tube_diameter = stage4_tube_value_at(
        station_x, stage4_tube_diameter);
    tube_radius = tube_diameter / 2;
    contact_radius = max(0.5, tube_radius - wall_thickness);
    hull_inner_y = 0.70 * stage4_v_half_width[i];
    hull_outer_y = stage4_v_half_width[i];

    hull() {
        for (hull_y = [hull_inner_y, hull_outer_y])
            translate([
                station_x,
                side * hull_y,
                stage4_keel_z[i]
                    + tan(reference_deadrise) * hull_y
            ])
                rotate([0, 90, 0])
                    cylinder(h = 1,
                        r = pontoon_hull_saddle_radius,
                        center = true, $fn = 24);

        // Broad three-point contact overlaps the pontoon shell instead of
        // merely touching it on a thin tangent line.
        for (contact_angle = [215, 238, 258])
            translate([
                station_x,
                side * (tube_y
                    + contact_radius * cos(contact_angle)),
                tube_z
                    + contact_radius * sin(contact_angle)
            ])
                rotate([0, 90, 0])
                    cylinder(h = 1,
                        r = pontoon_hull_saddle_radius,
                        center = true, $fn = 24);
    }
}

module stage4_pontoon_hull_saddles() {
    for (side = [-1, 1])
        // Continue the structural shoulder through the first bow station.
        // This overlaps both the V-shell and the pontoon shell and closes the
        // underside instead of leaving two individually closed volumes apart.
        for (i = [0 : len(stage4_x) - 2])
            hull() {
                stage4_saddle_station(i, side);
                stage4_saddle_station(i + 1, side);
            }
}

module stage4_bow_v_cap() {
    intersection() {
        stage4_v_outer();
        translate([stage4_x[0], 0, stage4_keel_z[0] + 10])
            cube([wall_thickness, 30, 30], center = true);
    }
}

module stage4_forward_structure() {
    union() {
        stage4_v_shell();
        stage4_pontoon_hull_saddles();
        stage4_pontoon_shells();
        stage4_bow_v_cap();
    }
}

module stage4_complete_structure() {
    union() {
        stage4_forward_structure();
        stern_structure();
    }
}

module stage4_section(x0, x1) {
    intersection() {
        stage4_complete_structure();
        translate([(x0 + x1) / 2, 0, 65])
            cube([
                x1 - x0 + boolean_overlap,
                printer_y,
                150
            ], center = true);
    }
}

module stage4_bow_section() {
    stage4_section(0, section_bow_end);
}

module stage4_mid_section() {
    stage4_section(section_bow_end, section_mid_end);
}

module stage4_stern_section() {
    stage4_section(section_mid_end,
        stern_aft_tip_x());
}
