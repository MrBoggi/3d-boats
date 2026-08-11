include <floor_stage1.scad>
use <hull_stage4.scad>

floor_crossbeam_x = [220, 430, 555];
floor_crossbeam_half_width = [64, 67, 60];
floor_crossbeam_size_x = 6;
floor_crossbeam_height = 5;
floor_support_leg_size = [8, 10];
floor_support_leg_y = [-45, 0, 45];

battery_tray_size = [112, 40, 3];
battery_tray_top_z = battery_clearance_center[2]
    - floor_battery_clearance[2] / 2 - 0.5;
esc_tray_size = [68, 44, 3];
esc_tray_top_z = esc_clearance_center[2]
    - floor_esc_clearance[2] / 2 - 0.5;
receiver_tray_size = [60, 40, 3];
receiver_tray_top_z = receiver_clearance_center[2]
    - floor_receiver_clearance[2] / 2 - 0.5;

floor_support_inner_offset = wall_thickness * 1.8;

function floor_v_support_z(x, y) =
    stage4_v_surface_z_at(x, y) + floor_support_inner_offset;

module floor_crossbeam(x, half_width) {
    translate([
        x,
        0,
        cockpit_floor_z - cockpit_floor_thickness
            - floor_crossbeam_height / 2
    ])
        cube([
            floor_crossbeam_size_x,
            2 * half_width,
            floor_crossbeam_height
        ], center = true);

    // Discrete legs reinforce the V without creating sealed transverse dams.
    for (leg_y = floor_support_leg_y) {
        leg_bottom_z = floor_v_support_z(x, leg_y) - boolean_overlap;
        hull_surface_z = stage4_v_surface_z_at(x, leg_y);
        leg_top_z = cockpit_floor_z - cockpit_floor_thickness;
        assert(leg_bottom_z > hull_surface_z,
            "Floor support leg protrudes below the V-bottom outer surface");
        translate([
            x,
            leg_y,
            (leg_bottom_z + leg_top_z) / 2
        ])
            cube([
                floor_support_leg_size[0],
                floor_support_leg_size[1],
                leg_top_z - leg_bottom_z
            ], center = true);
    }
}

module equipment_tray(center_xyz, size, top_z, strap_slots = false) {
    difference() {
        translate([center_xyz[0], center_xyz[1], top_z - size[2] / 2])
            cube(size, center = true);

        if (strap_slots)
            for (slot_x = [-size[0] / 3, size[0] / 3])
                translate([center_xyz[0] + slot_x, center_xyz[1], top_z])
                    cube([5, size[1] - 8,
                        size[2] + 2 * boolean_overlap], center = true);
    }

    // Four open standoffs; bilge water and wiring can pass between them.
    for (dx = [-size[0] / 2 + 8, size[0] / 2 - 8])
        for (dy = [-size[1] / 2 + 6, size[1] / 2 - 6]) {
            support_x = center_xyz[0] + dx;
            support_y = center_xyz[1] + dy;
            support_bottom_z = floor_v_support_z(support_x, support_y)
                - boolean_overlap;
            hull_surface_z = stage4_v_surface_z_at(support_x, support_y);
            assert(support_bottom_z > hull_surface_z,
                "Equipment standoff protrudes below the V-bottom surface");
            translate([
                center_xyz[0] + dx,
                center_xyz[1] + dy,
                (support_bottom_z + top_z - size[2]) / 2
            ])
                cylinder(
                    h = top_z - size[2] - support_bottom_z,
                    d = 7, center = true, $fn = 24);
        }
}

module floor_stage2_internal_structure() {
    union() {
        cockpit_floor_support_rails();

        for (i = [0 : len(floor_crossbeam_x) - 1])
            floor_crossbeam(
                floor_crossbeam_x[i],
                floor_crossbeam_half_width[i]);

        equipment_tray(
            battery_clearance_center,
            battery_tray_size,
            battery_tray_top_z,
            strap_slots = true);
        equipment_tray(
            esc_clearance_center,
            esc_tray_size,
            esc_tray_top_z);
        equipment_tray(
            receiver_clearance_center,
            receiver_tray_size,
            receiver_tray_top_z);
    }
}
