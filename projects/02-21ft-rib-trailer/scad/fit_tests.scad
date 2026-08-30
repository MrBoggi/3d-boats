include <config.scad>
use <frame.scad>
use <coupler.scad>
use <supports.scad>

// Full-scale coupons cut directly from production geometry.
module fit_v_joint_coupon(front = true) {
    center = [v_split_x, v_half_width_at(v_split_x), frame_bottom_z + drawbar_beam_height / 2];
    intersection() {
        if (front) drawbar_front(); else drawbar_rear();
        translate(center) cube([32, 30, drawbar_beam_height + 2], center = true);
    }
}
module fit_coupler_frame_coupon() {
    x = coupler_adapter_center_x + coupler_adapter_size[0] / 2 + coupler_tongue_length / 2;
    intersection() {
        drawbar_front();
        translate([x, 0, frame_bottom_z + drawbar_beam_height / 2])
            cube([coupler_tongue_length + 10, 18, drawbar_beam_height + 2], center = true);
    }
}
module fit_rail_splice_coupon(rear_half = false) {
    seam_x = 2 * frame_segment_length;
    intersection() {
        rail_segment(rear_half ? 2 : 1, 1);
        translate([seam_x, rail_center_y, frame_center_z])
            cube([frame_joint_lap_length + 4, rail_size[1] + 2,
                rail_size[2] + 2], center = true);
    }
}
module fit_crossmember_rail_coupon(index = 1) {
    intersection() {
        rail_segment(index <= 1 ? 1 : 2, 1);
        translate([crossmember_joint_rail_x(index), rail_center_y, frame_center_z])
            cube([30, rail_size[1] + 2, rail_size[2] + 2], center = true);
    }
}
module fit_crossmember_end_coupon(index = 1) {
    intersection() {
        crossmember(index);
        translate([crossmember_x[index], crossmember_joint_cross_y(index),
                frame_bottom_z + crossmember_size[2] / 2])
            cube([64, 34, crossmember_size[2] + 2], center = true);
    }
}
module fit_front_v_coupon() {
    intersection() {
        drawbar_rear();
        translate([v_rail_joint_front_x,
                v_half_width_at(v_rail_joint_front_x), frame_center_z])
            cube([30, 24, rail_size[2] + 2], center = true);
    }
}
module fit_side_support_post_head() {
    intersection() {
        side_support_post(0, 1);
        translate([side_support_x[0], side_support_y, side_support_top_z[0] - 4])
            cube([24, 24, 28], center = true);
    }
}
module fit_test_export(part) {
    if (part == "fit_v_front")
        translate([-v_split_x, -v_half_width_at(v_split_x), -frame_bottom_z]) fit_v_joint_coupon(true);
    else if (part == "fit_v_rear")
        translate([-v_split_x, -v_half_width_at(v_split_x), -frame_bottom_z]) fit_v_joint_coupon(false);
    else if (part == "fit_coupler_frame")
        translate([-coupler_adapter_center_x - coupler_adapter_size[0] / 2 - coupler_tongue_length / 2, 0, -frame_bottom_z]) fit_coupler_frame_coupon();
    else if (part == "fit_splice_front")
        translate([-2 * frame_segment_length, -rail_center_y, -frame_bottom_z]) fit_rail_splice_coupon(false);
    else if (part == "fit_splice_rear")
        translate([-2 * frame_segment_length, -rail_center_y, -frame_bottom_z]) fit_rail_splice_coupon(true);
    else if (part == "fit_front_v")
        translate([-v_rail_joint_front_x,
                -v_half_width_at(v_rail_joint_front_x), -frame_bottom_z])
            fit_front_v_coupon();
    else if (part == "fit_front_rail")
        translate([-v_rail_joint_rear_x, -rail_center_y, -frame_bottom_z])
            fit_crossmember_rail_coupon(0);
    else if (part == "fit_front_crossmember")
        translate([-crossmember_x[0], -crossmember_joint_cross_y(0),
                -frame_bottom_z]) fit_crossmember_end_coupon(0);
    else if (part == "fit_mid_rail")
        translate([-crossmember_joint_rail_x(1), -rail_center_y, -frame_bottom_z]) fit_crossmember_rail_coupon(1);
    else if (part == "fit_mid_crossmember")
        translate([-crossmember_x[1], -crossmember_joint_cross_y(1), -frame_bottom_z]) fit_crossmember_end_coupon(1);
    else if (part == "fit_rear_rail")
        translate([-crossmember_joint_rail_x(2), -rail_center_y, -frame_bottom_z]) fit_crossmember_rail_coupon(2);
    else if (part == "fit_rear_crossmember")
        translate([-crossmember_x[2], -crossmember_joint_cross_y(2), -frame_bottom_z]) fit_crossmember_end_coupon(2);
    else if (part == "fit_side_post_head")
        translate([-side_support_x[0], -side_support_y, -side_support_top_z[0] + support_post_pivot_boss_diameter / 2]) fit_side_support_post_head();
    else assert(false, str("Unknown fit-test part: ", part));
}
