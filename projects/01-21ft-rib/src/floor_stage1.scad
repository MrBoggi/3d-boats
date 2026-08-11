include <config.scad>

// Floor outline follows the usable space between the inner pontoon walls.
floor_station_x = [45, 60, 80, 105, 130, 160, 200, 250, 310, 370, 430, 490, 545, 588];
floor_station_half_width = [30, 36, 43, 52, 60, 67, 70, 72, 73, 73, 73, 71, 66, 58];
// Flat from X=160 aft. The bow stations rise with the pontoon/V-bottom
// junction so the floor remains inside the hull envelope.
floor_station_top_z = [72, 69, 65, 61, 58, 55, 55, 55, 55, 55, 55, 55, 55, 55];
// Raised molded shoulders from the console to the bow rail mounts.
bow_deck_x = [42, 70, 100, 130, 170, 215, 260, 297];
bow_deck_y = [24, 36, 47, 55, 62, 67, 69, 70];
bow_deck_width = [20, 22, 24, 24, 22, 19, 15, 12];


aft_hatch_center = [517, 0];
aft_hatch_size = [130, 100];
hatch_corner_radius = 7;

battery_clearance_center = [337, 0, 38.5];
esc_clearance_center = [465, 0, 37.5];
receiver_clearance_center = [530, 18, 39.5];

assert(floor_station_x[0] > 0);
assert(len(floor_station_x) == len(floor_station_top_z));
assert(floor_station_x[len(floor_station_x) - 1]
        < cockpit_floor_aft_limit);
assert(battery_hatch_size[0] < printer_x);
assert(aft_hatch_size[0] < printer_x);
assert(battery_hatch_center[0] + battery_hatch_size[0] / 2 + 10
        <= aft_hatch_center[0] - aft_hatch_size[0] / 2,
    "Battery and aft hatches require at least 10 mm fixed floor between them");
assert(battery_clearance_center[2]
        + floor_battery_clearance[2] / 2
        <= cockpit_floor_z - cockpit_floor_thickness / 2,
    "Battery clearance intersects the cockpit floor");
assert(esc_clearance_center[2] + floor_esc_clearance[2] / 2
        <= cockpit_floor_z - cockpit_floor_thickness / 2,
    "ESC clearance intersects the cockpit floor");
assert(receiver_clearance_center[2]
        + floor_receiver_clearance[2] / 2
        <= cockpit_floor_z - cockpit_floor_thickness / 2,
    "Receiver clearance intersects the cockpit floor");

module floor_station(i, thickness = cockpit_floor_thickness) {
    translate([
        floor_station_x[i],
        0,
        floor_station_top_z[i] - thickness / 2
    ])
        cube([
            1,
            2 * floor_station_half_width[i],
            thickness
        ], center = true);
}

function floor_top_z_at(x, i = 0) =
    x <= floor_station_x[0] ? floor_station_top_z[0] :
    x >= floor_station_x[len(floor_station_x) - 1]
        ? floor_station_top_z[len(floor_station_top_z) - 1] :
    x <= floor_station_x[i + 1]
        ? floor_station_top_z[i]
            + (floor_station_top_z[i + 1] - floor_station_top_z[i])
                * (x - floor_station_x[i])
                / (floor_station_x[i + 1] - floor_station_x[i])
        : floor_top_z_at(x, i + 1);

module cockpit_floor_outer() {
    union()
        for (i = [0 : len(floor_station_x) - 2])
            hull() {
                floor_station(i);
                floor_station(i + 1);
            }
}

module rounded_prism(size, height, radius) {
    hull()
        for (x = [-size[0] / 2 + radius,
                size[0] / 2 - radius])
            for (y = [-size[1] / 2 + radius,
                    size[1] / 2 - radius])
                translate([x, y, 0])
                    cylinder(h = height, r = radius,
                        center = true);
}

module floor_hatch_cut(center_xy, size) {
    translate([
        center_xy[0],
        center_xy[1],
        cockpit_floor_z
    ])
        rounded_prism(
            size,
            cockpit_floor_thickness + 2 * boolean_overlap,
            hatch_corner_radius);
}

module bow_deck_station(i, side) {
    station_floor_z = floor_top_z_at(bow_deck_x[i]);
    translate([
        bow_deck_x[i],
        side * bow_deck_y[i],
        station_floor_z + bow_deck_height / 2
            - boolean_overlap / 2
    ])
        rotate([0, 90, 0])
            linear_extrude(height = 1, center = true)
                offset(r = bow_deck_corner_radius)
                    square([
                        bow_deck_height + boolean_overlap
                            - 2 * bow_deck_corner_radius,
                        bow_deck_width[i]
                            - 2 * bow_deck_corner_radius
                    ], center = true);
}

module cockpit_bow_deck_shoulders() {
    for (side = [-1, 1])
        for (i = [0 : len(bow_deck_x) - 2])
            hull() {
                bow_deck_station(i, side);
                bow_deck_station(i + 1, side);
            }
}

module bow_rail_mount_sockets() {
    for (side = [-1, 1])
        translate([
            bow_rail_foot_xy[0],
            side * bow_rail_foot_xy[1],
            cockpit_floor_z + bow_deck_height
                - bow_rail_tenon_length / 2
                + boolean_overlap
        ])
            cylinder(
                h = bow_rail_tenon_length + 2 * boolean_overlap,
                d = bow_rail_tenon_diameter
                    + 2 * bow_rail_socket_clearance,
                center = true, $fn = 24);
}

module cockpit_floor_fixed() {
    difference() {
        union() {
            difference() {
                cockpit_floor_outer();
                floor_hatch_cut(battery_hatch_center, battery_hatch_size);
                floor_hatch_cut(aft_hatch_center, aft_hatch_size);
            }
            cockpit_bow_deck_shoulders();
        }
        bow_rail_mount_sockets();
    }
}

module floor_hatch_lid(center_xy, opening_size) {
    lid_size = [
        opening_size[0] - 2 * cockpit_floor_hatch_gap,
        opening_size[1] - 2 * cockpit_floor_hatch_gap
    ];

    translate([
        center_xy[0],
        center_xy[1],
        cockpit_floor_z - cockpit_floor_thickness / 2
    ])
        rounded_prism(
            lid_size,
            cockpit_floor_thickness,
            hatch_corner_radius - cockpit_floor_hatch_gap);
}

module floor_battery_lid() {
    floor_hatch_lid(battery_hatch_center, battery_hatch_size);
}

module floor_aft_lid() {
    difference() {
        floor_hatch_lid(aft_hatch_center, aft_hatch_size);

        // Servo body and steering arm pass through this panel. The removable
        // aft bench will cover the complete service zone.
        translate([
            steering_servo_axis[0] - 12,
            0,
            cockpit_floor_z
        ])
            rounded_prism([76, 60],
                cockpit_floor_thickness + 2 * boolean_overlap, 5);
    }
}

module floor_support_station(i, side) {
    translate([
        floor_station_x[i],
        side * (floor_station_half_width[i]
            - cockpit_floor_support_width / 2),
        floor_station_top_z[i]
            - cockpit_floor_thickness
            - cockpit_floor_support_height / 2
            + boolean_overlap
    ])
        cube([
            1,
            cockpit_floor_support_width,
            cockpit_floor_support_height
        ], center = true);
}

module cockpit_floor_support_rails() {
    for (side = [-1, 1])
        for (i = [0 : len(floor_station_x) - 2])
            hull() {
                floor_support_station(i, side);
                floor_support_station(i + 1, side);
            }
}

module floor_component_clearance(center_xyz, size) {
    translate(center_xyz)
        cube(size, center = true);
}

module floor_stage1_component_envelopes() {
    color([0.18, 0.48, 0.95, 0.45])
        floor_component_clearance(
            battery_clearance_center, floor_battery_clearance);
    color([0.85, 0.20, 0.12, 0.45])
        floor_component_clearance(
            esc_clearance_center, floor_esc_clearance);
    color([0.20, 0.75, 0.35, 0.45])
        floor_component_clearance(
            receiver_clearance_center, floor_receiver_clearance);
}

module floor_section(x0, x1) {
    intersection() {
        cockpit_floor_fixed();
        translate([(x0 + x1) / 2, 0, 65])
            cube([
                x1 - x0 + boolean_overlap,
                printer_y,
                40
            ], center = true);
    }
}

module floor_bow_section() {
    floor_section(0, section_bow_end);
}

module floor_mid_section() {
    floor_section(section_bow_end, section_mid_end);
}

module floor_stern_section() {
    floor_section(section_mid_end, cockpit_floor_aft_limit);
}
