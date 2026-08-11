include <config.scad>

assert(console_sections[0][1]
        >= battery_hatch_center[0] - battery_hatch_size[0] / 2,
    "Console bow edge extends beyond the removable battery hatch");
assert(console_sections[0][2]
        <= battery_hatch_center[0] + battery_hatch_size[0] / 2,
    "Console aft edge extends beyond the removable battery hatch");
assert(console_width <= battery_hatch_size[1],
    "Console width exceeds the removable battery hatch");
assert(console_center_y - console_width / 2
        >= battery_hatch_center[1] - battery_hatch_size[1] / 2,
    "Console port edge extends beyond the removable battery hatch");
assert(console_center_y + console_width / 2
        <= battery_hatch_center[1] + battery_hatch_size[1] / 2,
    "Console starboard edge extends beyond the removable battery hatch");
assert(console_center_y - console_base_size[1] / 2
        >= battery_hatch_center[1] - battery_hatch_size[1] / 2,
    "Console base port edge extends beyond the removable battery hatch");
assert(console_center_y + console_base_size[1] / 2
        <= battery_hatch_center[1] + battery_hatch_size[1] / 2,
    "Console base starboard edge extends beyond the removable battery hatch");
assert(67 + console_center_y - console_width / 2
        >= console_port_passage_min,
    "Port-side passage is narrower than the approved minimum");
assert(norm([
        console_windshield_rear_lower[0]
            - (console_windshield_front_lower[0]
                + console_windshield_curve_depth),
        console_windshield_rear_half_width
            - console_windshield_front_half_width
    ]) <= 11,
    "Windshield side wing exceeds 11 mm at 1:10 scale");
assert(abs(
        (console_sections[6][1] - console_sections[2][1])
            / (console_sections[6][0] - console_sections[2][0])
        - (console_windshield_front_upper[0]
            - console_windshield_front_lower[0])
            / (console_windshield_front_upper[1]
                - console_windshield_front_lower[1])
    ) < 0.01,
    "Console front and windshield must retain the same aft rake");
assert(console_frame_lower_anchor[1] - cockpit_floor_z >= 20,
    "Windshield hoop must start at least 20 mm above deck level");
assert(console_dashboard_recess_depth == 10,
    "Dashboard recess must remain 10 mm deep at 1:10 scale");
assert(console_dashboard_recess_upper[1]
        - console_dashboard_recess_lower[1] >= 34,
    "Dashboard recess must cover at least 34 mm vertically");
assert(console_windshield_curve_depth > 0,
    "Windshield must retain the console-matching front curvature");
assert(console_oled_pcb_size[1] < console_dashboard_recess_width,
    "OLED PCB is wider than the dashboard recess");
assert(console_oled_pcb_size[2]
        < console_dashboard_recess_upper[1]
            - console_dashboard_recess_lower[1],
    "OLED PCB is taller than the dashboard recess");

module console_rounded_xy_prism(size, radius) {
    hull()
        for (x = [-size[0] / 2 + radius,
                size[0] / 2 - radius])
            for (y = [-size[1] / 2 + radius,
                    size[1] / 2 - radius])
                translate([x, y, 0])
                    cylinder(h = size[2], r = radius, center = true);
}

module console_section_node(section, inset = 0, z_override = undef) {
    section_z = is_undef(z_override) ? section[0] : z_override;
    section_front = section[1] + inset;
    section_rear = section[2] - inset;
    section_length = section_rear - section_front;
    section_width = section[3] - 2 * inset;
    section_radius = max(1, section[4] - inset);
    section_front_curve = max(1, section[5] - inset / 2);
    section_half_width = section_width / 2;
    section_profile = [
        [section_front + section_front_curve,
            -section_half_width],
        [section_front + section_front_curve * 0.42,
            -section_half_width * 0.62],
        [section_front + section_front_curve * 0.10,
            -section_half_width * 0.28],
        [section_front, 0],
        [section_front + section_front_curve * 0.10,
            section_half_width * 0.28],
        [section_front + section_front_curve * 0.42,
            section_half_width * 0.62],
        [section_front + section_front_curve,
            section_half_width],
        [section_rear, section_half_width],
        [section_rear, -section_half_width]
    ];

    assert(section_length > 2 * section_radius,
        "Console section is too short for its corner radius");
    assert(section_width > 2 * section_radius,
        "Console section is too narrow for its corner radius");

    translate([0, console_center_y, section_z - 0.5])
        linear_extrude(height = 1, convexity = 6)
            offset(r = section_radius)
                offset(delta = -section_radius)
                    polygon(points = section_profile);
}

module console_section_loft(sections, inset = 0, inner = false) {
    for (index = [0 : len(sections) - 2])
        hull() {
            console_section_node(
                sections[index],
                inset,
                inner && index == 0
                    ? sections[index][0] - boolean_overlap
                    : undef);
            console_section_node(
                sections[index + 1],
                inset,
                inner && index + 1 == len(sections) - 1
                    ? sections[index + 1][0] - console_wall_thickness
                    : undef);
        }
}

module console_outer_stage1() {
    console_section_loft(console_sections);
}

module console_inner_stage1() {
    console_section_loft(
        console_sections,
        console_wall_thickness,
        true);
}

module console_shell_stage1() {
    difference() {
        union() {
            difference() {
                console_outer_stage1();
                console_inner_stage1();
                console_dashboard_recess_cutter();
            }
            console_hoop_receiver_bosses();
            console_dashboard_recess_backing();
            console_oled_mount_bosses();
        }
        console_hoop_receiver_pilot_holes();
        console_oled_window_cutter();
        console_oled_mount_pilot_holes();
    }
}

module console_dashboard_reference() {
    // Dark visual insert on one flat printable backing plane.
    hull() {
        for (point = [console_dashboard_recess_lower,
                console_dashboard_recess_upper])
            for (y_offset = [-console_dashboard_recess_width / 2,
                    console_dashboard_recess_width / 2])
                console_dashboard_flat_node(
                    point, y_offset, 1.4,
                    console_dashboard_recess_depth - 0.4);
    }
}

module console_dashboard_flat_node(
        point_xz, y_offset, diameter, recess_depth = 0) {
    translate([
        point_xz[0] - recess_depth,
        console_center_y + y_offset,
        point_xz[1]
    ])
        sphere(d = diameter, $fn = 28);
}

module console_dashboard_recess_cutter() {
    // Only opens the outer shell; the liner closes the resulting aperture.
    hull() {
        for (depth_offset = [-3, 5])
            for (point = [console_dashboard_recess_lower,
                    console_dashboard_recess_upper])
                for (y_offset = [-console_dashboard_recess_width / 2,
                        console_dashboard_recess_width / 2])
                    console_dashboard_flat_node(
                        point,
                        y_offset,
                        console_dashboard_recess_corner_diameter,
                        depth_offset);
    }
}

module console_dashboard_recess_backing_raw() {
    wall_thickness = 2.4;
    half_width = console_dashboard_recess_width / 2;
    anchor_overlap = console_dashboard_anchor_overlap;

    // One continuous rounded cup replaces four intersecting wall hulls.
    // Its front lip overlaps the shell; the smaller cavity stops short of
    // the rear plane and therefore leaves a flat, integral backing wall.
    difference() {
        hull() {
            for (side = [-1, 1]) {
                console_dashboard_flat_node(
                    [console_dashboard_recess_lower[0],
                        console_dashboard_recess_lower[1]
                            - anchor_overlap],
                    side * (half_width + anchor_overlap),
                    console_dashboard_recess_corner_diameter,
                    0);
                console_dashboard_flat_node(
                    [console_dashboard_recess_upper[0],
                        console_dashboard_recess_upper[1]
                            + anchor_overlap],
                    side * (half_width + anchor_overlap),
                    console_dashboard_recess_corner_diameter,
                    0);
                console_dashboard_flat_node(
                    [console_dashboard_recess_lower[0],
                        console_dashboard_recess_lower[1]
                            - wall_thickness],
                    side * (half_width + wall_thickness),
                    console_dashboard_recess_corner_diameter,
                    console_dashboard_recess_depth);
                console_dashboard_flat_node(
                    [console_dashboard_recess_upper[0],
                        console_dashboard_recess_upper[1]
                            + wall_thickness],
                    side * (half_width + wall_thickness),
                    console_dashboard_recess_corner_diameter,
                    console_dashboard_recess_depth);
            }
        }

        hull()
            for (depth = [-3,
                    console_dashboard_recess_depth - wall_thickness])
                for (point = [console_dashboard_recess_lower,
                        console_dashboard_recess_upper])
                    for (side = [-1, 1])
                        console_dashboard_flat_node(
                            point,
                            side * half_width,
                            console_dashboard_recess_corner_diameter,
                            depth);
    }
}

module console_dashboard_recess_backing() {
    intersection() {
        console_dashboard_recess_backing_raw();
        console_outer_stage1();
    }
}

module console_dashboard_local_frame() {
    dashboard_delta = console_dashboard_recess_upper
        - console_dashboard_recess_lower;
    dashboard_rake = atan(-dashboard_delta[0] / dashboard_delta[1]);

    translate([
        console_dashboard_recess_lower[0]
            - console_dashboard_recess_depth,
        console_center_y,
        console_dashboard_recess_lower[1]
    ])
        rotate([0, -dashboard_rake, 0])
            children();
}

module console_steering_wheel_reference() {
    rim_diameter = console_steering_wheel_diameter;
    rim_thickness = console_steering_wheel_rim_diameter;

    translate([2.5, -15, 12])
        rotate([0, 90, 0]) {
            rotate_extrude($fn = 40)
                translate([rim_diameter / 2, 0])
                    circle(d = rim_thickness, $fn = 16);
            cylinder(h = 3, d = 4.5, center = true, $fn = 24);
            for (angle = [0, 120, 240])
                rotate([0, 0, angle])
                    hull() {
                        cylinder(h = 1.3, d = 2.8,
                            center = true, $fn = 16);
                        translate([rim_diameter * 0.34, 0, 0])
                            cylinder(h = 1.3, d = 1.4,
                                center = true, $fn = 16);
                    }
        }
}

module console_dashboard_device_box(size, radius) {
    assert(size[1] > 2 * radius && size[2] > 2 * radius,
        "Dashboard device is too small for its corner radius");

    hull()
        for (y = [-size[1] / 2 + radius,
                size[1] / 2 - radius])
            for (z = [-size[2] / 2 + radius,
                    size[2] / 2 - radius])
                translate([0, y, z])
                    rotate([0, 90, 0])
                        cylinder(h = size[0], r = radius,
                            center = true, $fn = 20);
}

module console_oled_window_shape(depth) {
    size = console_oled_window_size;
    radius = console_oled_window_corner_radius;

    hull()
        for (y = [-size[0] / 2 + radius,
                size[0] / 2 - radius])
            for (z = [-size[1] / 2 + radius,
                    size[1] / 2 - radius])
                translate([0, y, z])
                    rotate([0, 90, 0])
                        cylinder(h = depth, r = radius,
                            center = true, $fn = 20);
}

module console_oled_window_cutter() {
    console_dashboard_local_frame()
        translate([0,
                console_oled_panel_center[0],
                console_oled_panel_center[1]])
            console_oled_window_shape(16);
}

module console_oled_mount_bosses() {
    console_dashboard_local_frame()
        for (y_offset = [-console_oled_mount_offsets[0],
                console_oled_mount_offsets[0]])
            for (z_offset = [-console_oled_mount_offsets[1],
                    console_oled_mount_offsets[1]])
                translate([-2.5,
                    console_oled_panel_center[0] + y_offset,
                    console_oled_panel_center[1] + z_offset])
                    rotate([0, 90, 0])
                        cylinder(h = 7,
                            d = console_oled_mount_boss_diameter,
                            center = true, $fn = 28);
}

module console_oled_mount_pilot_holes() {
    console_dashboard_local_frame()
        for (y_offset = [-console_oled_mount_offsets[0],
                console_oled_mount_offsets[0]])
            for (z_offset = [-console_oled_mount_offsets[1],
                    console_oled_mount_offsets[1]])
                translate([-3,
                    console_oled_panel_center[0] + y_offset,
                    console_oled_panel_center[1] + z_offset])
                    rotate([0, 90, 0])
                        cylinder(h = 10,
                            d = console_oled_mount_pilot_diameter,
                            center = true, $fn = 20);
}

module console_oled_retainer_part() {
    pcb_width = console_oled_pcb_size[1]
        + console_oled_retainer_clearance;
    pcb_height = console_oled_pcb_size[2]
        + console_oled_retainer_clearance;
    outer_width = 2 * console_oled_mount_offsets[0]
        + console_oled_mount_boss_diameter;
    outer_height = pcb_height + 2.4;
    inner_width = pcb_width
        - 2 * console_oled_retainer_edge_overlap;
    inner_height = pcb_height
        - 2 * console_oled_retainer_edge_overlap;

    difference() {
        console_dashboard_device_box(
            [console_oled_retainer_thickness,
                outer_width, outer_height], 2.2);
        translate([0, 0, 0])
            cube([console_oled_retainer_thickness + 2,
                inner_width, inner_height], center = true);
        for (y_offset = [-console_oled_mount_offsets[0],
                console_oled_mount_offsets[0]])
            for (z_offset = [-console_oled_mount_offsets[1],
                    console_oled_mount_offsets[1]])
                translate([0, y_offset, z_offset])
                    rotate([0, 90, 0])
                        cylinder(h = console_oled_retainer_thickness + 2,
                            d = console_oled_mount_pilot_diameter + 0.4,
                            center = true, $fn = 20);
    }
}

module console_chartplotter_reference() {
    console_dashboard_local_frame()
        translate([-console_oled_pcb_size[0] / 2,
                console_oled_panel_center[0],
                console_oled_panel_center[1]]) {
            color([0.08, 0.12, 0.10, 0.65])
                console_dashboard_device_box(
                    console_oled_pcb_size, 1.2);
            color([0.10, 0.48, 0.70])
                translate([console_oled_pcb_size[0] / 2 + 0.8,
                        0, 0])
                    cube([0.8,
                        console_oled_active_size[0],
                        console_oled_active_size[1]], center = true);
        }
}

module console_throttle_reference() {
    size = console_throttle_size;

    translate([size[0] / 2 + 0.8,
            console_throttle_panel_center[0],
            console_throttle_panel_center[1]]) {
        // Low mounting flange and the domed control-box body.
        console_dashboard_device_box(
            [1.8, size[1] + 2, size[2] + 2], 1.8);
        translate([1.8, 0, 0.8])
            console_dashboard_device_box(size, 2.5);

        // Connected pivot, upright arm and forward-curved hand grip.
        translate([size[0] / 2 + 2.2, 0, 1.5])
            rotate([90, 0, 0])
                cylinder(h = size[1] + 1, d = 3.8,
                    center = true, $fn = 24);
        hull() {
            translate([size[0] / 2 + 2.2, 0, 1.5])
                sphere(d = 3.4, $fn = 24);
            translate([size[0] / 2 + 3.2, 0, 8.5])
                sphere(d = 3.6, $fn = 24);
        }
        hull() {
            translate([size[0] / 2 + 3.2, 0, 8.5])
                sphere(d = 3.6, $fn = 24);
            translate([size[0] / 2 + 6.2, 0, 10.5])
                sphere(d = 4.2, $fn = 24);
        }
    }
}

module console_dashboard_controls_reference() {
    console_dashboard_local_frame() {
        color([0.05, 0.05, 0.06])
            console_steering_wheel_reference();
        color([0.06, 0.07, 0.08])
            console_throttle_reference();
    }
    console_chartplotter_reference();
}

module console_windshield_panel_reference() {
    curve_stations = [-1, -0.67, -0.33, 0, 0.33, 0.67, 1];

    module front_panel_node(point_xz, station) {
        translate([
            point_xz[0]
                + console_windshield_curve_depth
                    * station * station,
            console_center_y
                + station * console_windshield_front_half_width,
            point_xz[1]
        ])
            cube([1.4, 1.4, 2], center = true);
    }

    module rear_panel_node(point_xz, side) {
        translate([
            point_xz[0],
            console_center_y
                + side * console_windshield_rear_half_width,
            point_xz[1]
        ])
            cube([1.4, 1.4, 2], center = true);
    }

    // Six shallow panels approximate the rounded console-front curve.
    for (index = [0 : len(curve_stations) - 2])
        hull() {
            for (station = [curve_stations[index],
                    curve_stations[index + 1]]) {
                front_panel_node(
                    console_windshield_front_lower, station);
                front_panel_node(
                    console_windshield_front_upper, station);
            }
        }

    // Side wings wrap aft to the upper edge of the dashboard.
    for (side = [-1, 1])
        hull() {
            front_panel_node(console_windshield_front_lower, side);
            front_panel_node(console_windshield_front_upper, side);
            rear_panel_node(console_windshield_rear_lower, side);
            rear_panel_node(console_windshield_rear_upper, side);
        }
}

module console_frame_node(point_xz, half_width, side) {
    translate([
        point_xz[0],
        console_center_y + side * half_width,
        point_xz[1]
    ])
        sphere(d = console_frame_diameter, $fn = 24);
}

module console_frame_segment(point_a, width_a, point_b, width_b, side) {
    hull() {
        console_frame_node(point_a, width_a, side);
        console_frame_node(point_b, width_b, side);
    }
}

module console_axis_y_cylinder(diameter, length) {
    rotate([90, 0, 0])
        cylinder(h = length, d = diameter, center = true, $fn = 28);
}

module console_hoop_mount_tenons() {
    for (side = [-1, 1])
        translate([
            console_frame_lower_anchor[0],
            console_center_y
                + side * (console_frame_half_width
                    - console_hoop_tenon_length / 2),
            console_frame_lower_anchor[1]
        ])
            console_axis_y_cylinder(
                console_hoop_tenon_diameter,
                console_hoop_tenon_length);
}

module console_hoop_receiver_bosses() {
    for (side = [-1, 1])
        translate([
            console_frame_lower_anchor[0],
            console_center_y
                + side * (console_frame_half_width
                    - console_hoop_tenon_length),
            console_frame_lower_anchor[1]
        ])
            console_axis_y_cylinder(
                console_hoop_socket_boss_diameter,
                console_hoop_tenon_length);
}

module console_hoop_receiver_pilot_holes() {
    for (side = [-1, 1]) {
        translate([
            console_frame_lower_anchor[0],
            console_center_y
                + side * (console_frame_half_width
                    - console_hoop_tenon_length),
            console_frame_lower_anchor[1]
        ])
            console_axis_y_cylinder(
                console_hoop_tenon_diameter
                    + console_hoop_socket_clearance,
                console_hoop_tenon_length + 2 * boolean_overlap);

        // Optional vertical M1.6 locking screw bites into the inserted tenon.
        translate([
            console_frame_lower_anchor[0],
            console_center_y
                + side * (console_frame_half_width
                    - console_hoop_tenon_length),
            console_frame_lower_anchor[1] + 2
        ])
            cylinder(
                h = 5,
                d = console_hoop_lock_pilot_diameter,
                center = true,
                $fn = 24);
    }
}

module console_screen_attachment_tab(side, fraction) {
    hoop_point = console_windshield_rear_lower
        + fraction * (console_windshield_rear_upper
            - console_windshield_rear_lower);

    hull() {
        translate([
            hoop_point[0],
            console_center_y + side * console_hoop_half_width,
            hoop_point[1]
        ])
            sphere(d = console_screen_tab_diameter, $fn = 20);
        translate([
            hoop_point[0],
            console_center_y
                + side * console_windshield_rear_half_width,
            hoop_point[1]
        ])
            sphere(d = console_screen_tab_diameter, $fn = 20);
    }
}

module console_windshield_frame_reference() {
    for (side = [-1, 1]) {
        console_frame_segment(console_frame_lower_anchor,
            console_frame_half_width, console_frame_shoulder,
            console_frame_half_width, side);
        console_frame_segment(console_frame_shoulder,
            console_frame_half_width, console_windshield_rear_lower,
            console_hoop_half_width, side);
        console_frame_segment(console_windshield_rear_lower,
            console_hoop_half_width,
            console_windshield_rear_upper,
            console_hoop_half_width, side);

        for (fraction = [0.2, 0.5, 0.8])
            console_screen_attachment_tab(side, fraction);
    }

    hull() {
        console_frame_node(console_windshield_rear_upper,
            console_hoop_half_width, -1);
        console_frame_node(console_windshield_rear_upper,
            console_hoop_half_width, 1);
    }
}

module console_windshield_hoop_part() {
    union() {
        console_windshield_frame_reference();
        console_hoop_mount_tenons();
    }
}
