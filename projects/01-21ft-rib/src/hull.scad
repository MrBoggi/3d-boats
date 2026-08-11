include <config.scad>
use <hardware.scad>

station_x = [0, 35, 120, 220, 330, 430, 540, 640];
station_width = [18, 100, 190, 224, 240, 240, 232, 205];
station_keel = [38, 18, 2, 0, 0, 1, 3, 8];
station_tube_z = [70, 69, 66, 63, 61, 60, 60, 62];
station_tube_scale = [0.55, 0.90, 1, 1, 1, 1, 0.96, 0.95];

module triangular_station(x, width, keel_z, top_z, thickness = 1) {
    polyhedron(
        points = [
            [x - thickness / 2, -width / 2, top_z],
            [x - thickness / 2, width / 2, top_z],
            [x - thickness / 2, 0, keel_z],
            [x + thickness / 2, -width / 2, top_z],
            [x + thickness / 2, width / 2, top_z],
            [x + thickness / 2, 0, keel_z]
        ],
        faces = [
            [0, 2, 1], [3, 4, 5],
            [0, 1, 4, 3], [1, 2, 5, 4], [2, 0, 3, 5]
        ],
        convexity = 4
    );
}

module lofted_v_hull(inset = 0, raised_keel = 0, top_extra = 0) {
    for (i = [0 : len(station_x) - 2])
        hull() {
            triangular_station(station_x[i],
                max(4, station_width[i] - 2 * inset),
                station_keel[i] + raised_keel,
                hull_deck_z + top_extra);
            triangular_station(station_x[i + 1],
                max(4, station_width[i + 1] - 2 * inset),
                station_keel[i + 1] + raised_keel,
                hull_deck_z + top_extra);
        }
}

module pontoon_station(i, side, radius_delta = 0) {
    radius = max(3,
        pontoon_radius * station_tube_scale[i] - radius_delta);
    y = max(0, station_width[i] / 2 - pontoon_radius);
    translate([station_x[i], side * y, station_tube_z[i]])
        rotate([0, 90, 0])
            cylinder(h = 1, r = radius, center = true);
}
module pontoon_stern_cap(side, thickness = wall_thickness) {
    i = len(station_x) - 1;
    radius = pontoon_radius * station_tube_scale[i];
    y = station_width[i] / 2 - pontoon_radius;

    translate([station_x[i], side * y, station_tube_z[i]])
        rotate([0, 90, 0])
            cylinder(h = thickness, r = radius, center = true);
}


module pontoons(radius_delta = 0) {
    for (side = [-1, 1])
        for (i = [0 : len(station_x) - 2])
            hull() {
                pontoon_station(i, side, radius_delta);
                pontoon_station(i + 1, side, radius_delta);
            }
}

module hull_shell() {
    difference() {
        union() {
            lofted_v_hull();
            pontoons();
        }
        union() {
            lofted_v_hull(inset = wall_thickness,
                raised_keel = wall_thickness * 1.8,
                top_extra = 12);
            pontoons(radius_delta = wall_thickness);
        }
    }
}

module floor_pan() {
    translate([320, 0, 37])
        cube([445, 132, 3], center = true);
}

module rectangular_frame(outer, inner, height) {
    difference() {
        cube([outer[0], outer[1], height], center = true);
        cube([inner[0], inner[1], height + 2 * boolean_overlap], center = true);
    }
}

module service_coamings() {
    translate([315, 0, hull_deck_z + 5])
        rectangular_frame([174, 144], [158, 128], 10);
    translate([515, 0, hull_deck_z + 5])
        rectangular_frame([184, 144], [168, 128], 10);
}

module transom_reinforcement() {
    translate([634, 0, 57]) cube([10, 130, 48], center = true);
    for (y = [-52, 52])
        hull() {
            translate([610, y, 39]) cube([35, 4, 4], center = true);
            translate([633, y, 66]) cube([4, 4, 48], center = true);
        }
}

module section_bulkhead(x) {
    intersection() {
        union() {
            lofted_v_hull();
            pontoons();
        }
        translate([x, 0, 55])
            cube([wall_thickness, boat_width + 2, 120], center = true);
    }
}

module joint_keys(x) {
    for (y = [-58, 0, 58])
        translate([x + joint_land / 2, y, 48])
            cube([joint_land + 4, 12, 10], center = true);
}

module joint_key_sockets(x) {
    for (y = [-58, 0, 58])
        translate([x + joint_land / 2, y, 48])
            cube([joint_land + 5, 12 + 2 * glue_gap,
                10 + 2 * glue_gap], center = true);
}

module joint_bolt_holes(x) {
    for (y = [-83, 83])
        translate([x, y, 53])
            rotate([0, 90, 0])
                cylinder(h = 18, d = 3 + fastener_clearance, center = true);
}

module shaft_passage() {
    translate([585, 0, 24])
        rotate([0, 90 - shaft_angle, 0])
            cylinder(h = 145, d = shaft_tube_diameter, center = true);
}

module complete_hull() {
    difference() {
        union() {
            hull_shell();
            floor_pan();
            service_coamings();
            transom_reinforcement();
            section_bulkhead(section_bow_end);
            section_bulkhead(section_mid_end);
            equipment_mounts();
        }
        shaft_passage();
    }
}

module hull_section(x0, x1) {
    intersection() {
        complete_hull();
        translate([(x0 + x1) / 2, 0, 60])
            cube([x1 - x0 + boolean_overlap, boat_width + 2, 145], center = true);
    }
}

module hull_bow() {
    difference() {
        union() {
            hull_section(0, section_bow_end);
            joint_keys(section_bow_end);
        }
        joint_bolt_holes(section_bow_end);
    }
}

module hull_mid() {
    difference() {
        union() {
            hull_section(section_bow_end, section_mid_end);
            joint_keys(section_mid_end);
        }
        joint_key_sockets(section_bow_end);
        joint_bolt_holes(section_bow_end);
        joint_bolt_holes(section_mid_end);
    }
}

module hull_stern() {
    difference() {
        hull_section(section_mid_end, boat_length);
        joint_key_sockets(section_mid_end);
        joint_bolt_holes(section_mid_end);
    }
}
