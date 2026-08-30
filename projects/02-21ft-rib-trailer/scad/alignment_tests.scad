include <config.scad>
use <frame.scad>

// Keep the exact production solid, but retain only a thin bottom web between
// full-height joint/hole zones supplied as the second child.
module alignment_reduced_part() {
    intersection() {
        children(0);
        union() {
            translate([-1000, -500, frame_bottom_z])
                cube([2000, 1000, alignment_web_thickness]);
            children(1);
        }
    }
}

module alignment_full_height_box(center, size) {
    translate([center[0], center[1], frame_center_z])
        cube([size[0], size[1], rail_size[2] + 2 * boolean_overlap],
            center = true);
}

module alignment_hole_zone(x, y, diameter = alignment_hole_boss_diameter) {
    translate([x, y, frame_center_z])
        cylinder(h = rail_size[2] + 2 * boolean_overlap,
            d = diameter, center = true);
}

module alignment_drawbar_front() {
    alignment_reduced_part() {
        drawbar_front();
        union() {
            // Coupler tongue/bolts, winch bridge, and both half-lap joints.
            alignment_full_height_box([-101, 0], [30, 42]);
            alignment_full_height_box([winch_bridge_x, 0],
                [crossmember_size[0] + 2 * alignment_joint_margin,
                    2 * v_half_width_at(winch_bridge_x) + 8]);
            alignment_full_height_box([v_split_x, 0],
                [2 * v_joint_overlap + 2 * alignment_joint_margin,
                    2 * v_half_width_at(v_split_x) + 28]);
        }
    }
}

module alignment_drawbar_rear() {
    alignment_reduced_part() {
        drawbar_rear();
        union() {
            alignment_full_height_box([v_split_x, 0],
                [2 * v_joint_overlap + 2 * alignment_joint_margin,
                    2 * v_half_width_at(v_split_x) + 28]);
            alignment_full_height_box([v_rail_joint_front_x, 0],
                [2 * alignment_joint_margin + 18, frame_outer_width + 12]);
            for (side = [-1, 1])
                alignment_hole_zone(v_front_roller_x, side * 12);
        }
    }
}

module alignment_rail_segment(index = 1, side = 1) {
    start_x = rail_segment_start(index);
    end_x = rail_segment_end(index);
    alignment_reduced_part() {
        rail_segment(index, side);
        union() {
            alignment_full_height_box([start_x + alignment_joint_margin / 2,
                    side * rail_center_y],
                [alignment_joint_margin, rail_size[1] + 2]);
            alignment_full_height_box([end_x - alignment_joint_margin / 2,
                    side * rail_center_y],
                [alignment_joint_margin, rail_size[1] + 2]);
            if (index == 1)
                alignment_hole_zone(v_rail_joint_rear_x,
                    side * rail_center_y);
            if (index == 2)
                for (x = [bogie_center_x - bogie_mount_hole_spacing / 2,
                        bogie_center_x + bogie_mount_hole_spacing / 2])
                    alignment_hole_zone(x, side * rail_center_y);
            if (index > 1)
                alignment_hole_zone(index * frame_segment_length
                    + splice_hole_spacing / 2, side * rail_center_y);
            if (index < 2)
                alignment_hole_zone((index + 1) * frame_segment_length
                    - splice_hole_spacing / 2, side * rail_center_y);
            for (member_index = [1 : len(crossmember_x) - 1]) {
                x = crossmember_joint_rail_x(member_index);
                if (x >= start_x && x <= end_x)
                    alignment_hole_zone(x, side * rail_center_y);
            }
        }
    }
}

module alignment_crossmember(index = 0) {
    width = index == 1 ? crossmember_inner_width : frame_outer_width;
    alignment_reduced_part() {
        crossmember(index);
        union() {
            // Full-height ends ensure the real mounting faces are tested.
            for (side = [-1, 1])
                alignment_full_height_box([crossmember_x[index],
                        side * (width / 2 - alignment_joint_margin / 2)],
                    [crossmember_size[0] + 2, alignment_joint_margin]);
            for (side = [-1, 1]) {
                joint_y = index == 0 ? crossmember_bolt_offset_y
                    : crossmember_joint_cross_y(index);
                alignment_hole_zone(crossmember_x[index], side * joint_y);
                alignment_hole_zone(crossmember_x[index], side * 12);
            }
            for (support_x = side_support_x)
                if (crossmember_x[index] == support_x)
                    for (side = [-1, 1])
                        for (offset = [-support_receiver_mount_hole_spacing / 2,
                                support_receiver_mount_hole_spacing / 2])
                            alignment_hole_zone(crossmember_x[index],
                                side * side_support_y + offset);
        }
    }
}

module alignment_test_export(part) {
    if (part == "alignment_drawbar_front")
        translate([0, 0, -frame_bottom_z]) alignment_drawbar_front();
    else if (part == "alignment_drawbar_rear")
        translate([0, 0, -frame_bottom_z]) alignment_drawbar_rear();
    else if (part == "alignment_frame_rail_middle")
        translate([-(rail_segment_start(1) + rail_segment_end(1)) / 2,
                -rail_center_y, -frame_bottom_z])
            alignment_rail_segment(1, 1);
    else if (part == "alignment_frame_rail_rear")
        translate([-(rail_segment_start(2) + rail_segment_end(2)) / 2,
                -rail_center_y, -frame_bottom_z])
            alignment_rail_segment(2, 1);
    else if (part == "alignment_crossmember")
        translate([-crossmember_x[0], 0, -frame_bottom_z])
            alignment_crossmember(0);
    else if (part == "alignment_crossmember_mid")
        translate([-crossmember_x[1], 0, -frame_bottom_z])
            alignment_crossmember(1);
    else if (part == "alignment_rear_accessory_crossmember")
        translate([-crossmember_x[2], 0, -frame_bottom_z])
            alignment_crossmember(2);
    else
        assert(false, str("Unknown alignment-test part: ", part));
}

module alignment_guide_number(value, position, size = 14) {
    color("yellow")
        translate([position[0], position[1],
                frame_bottom_z + rail_size[2] + 8])
            linear_extrude(height = 1)
                text(value, size = size, halign = "center", valign = "center");
}

// Numbered top-view assembly reference for already printed test parts.
module alignment_assembly_guide() {
    color("orange") alignment_drawbar_front();
    color("gold") alignment_drawbar_rear();
    for (side = [-1, 1]) {
        color("deepskyblue") alignment_rail_segment(1, side);
        color("royalblue") alignment_rail_segment(2, side);
    }
    color("limegreen") alignment_crossmember(0);
    color("green") alignment_crossmember(1);
    color("darkgreen") alignment_crossmember(2);

    alignment_guide_number("1", [-45, 0], 18);
    alignment_guide_number("2", [165, 0], 18);
    alignment_guide_number("3", [350, -rail_center_y], 15);
    alignment_guide_number("3", [350, rail_center_y], 15);
    alignment_guide_number("4", [520, -rail_center_y], 15);
    alignment_guide_number("4", [520, rail_center_y], 15);
    alignment_guide_number("5", [270, 0], 14);
    alignment_guide_number("6", [430, 0], 14);
    alignment_guide_number("7", [rear_accessory_x, 0], 14);
}
