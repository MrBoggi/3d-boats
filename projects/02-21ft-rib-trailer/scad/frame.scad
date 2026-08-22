include <config.scad>

module rail_splice_hole(x, side) {
    translate([x, side * rail_center_y, frame_center_z])
        rotate([90, 0, 0])
            cylinder(h = rail_size[1] + 2 * boolean_overlap,
                d = splice_hole_diameter, center = true);
}

function rail_segment_start(index) =
    index == 1 ? rail_front_x : frame_front_x + index * frame_segment_length;
function rail_segment_end(index) =
    index == 2 ? frame_rear_x
        : frame_front_x + (index + 1) * frame_segment_length;

module rail_segment(index = 0, side = 1) {
    assert(index >= 1 && index <= 2);
    segment_start_x = rail_segment_start(index);
    segment_end_x = rail_segment_end(index);
    segment_length = segment_end_x - segment_start_x;
    segment_center_x = (segment_start_x + segment_end_x) / 2;

    difference() {
        translate([segment_center_x, side * rail_center_y, frame_center_z])
            cube([segment_length, rail_size[1], rail_size[2]], center = true);

        if (index == 1)
            translate([v_rail_joint_rear_x, side * rail_center_y,
                    frame_center_z])
                cylinder(h = rail_size[2] + 2 * boolean_overlap,
                    d = crossmember_bolt_diameter, center = true);

        if (index == 2) {
            for (mount_x = [bogie_center_x - bogie_mount_hole_spacing / 2,
                    bogie_center_x + bogie_mount_hole_spacing / 2])
                translate([mount_x, side * rail_center_y, frame_center_z])
                    cylinder(h = rail_size[2] + 2 * boolean_overlap,
                        d = m3_clearance, center = true);
        }

        if (index > 1)
            rail_splice_hole(index * frame_segment_length
                + splice_hole_spacing / 2, side);
        if (index < 2)
            rail_splice_hole((index + 1) * frame_segment_length
                - splice_hole_spacing / 2, side);

        for (member_index = [1 : len(crossmember_x) - 1]) {
            joint_x = crossmember_joint_rail_x(member_index);
            if (joint_x >= segment_start_x && joint_x <= segment_end_x)
                translate([joint_x, side * rail_center_y, frame_center_z])
                    cylinder(h = rail_size[2] + 2 * boolean_overlap,
                        d = crossmember_bolt_diameter, center = true);
        }
    }
}

module rail_segment_export(index = 1) {
    segment_center_x = (rail_segment_start(index)
        + rail_segment_end(index)) / 2;
    translate([-segment_center_x, -rail_center_y, -frame_bottom_z])
        rail_segment(index, 1);
}

module splice_plate() {
    difference() {
        cube(splice_size, center = true);
        for (x = [-splice_hole_spacing / 2,
                splice_hole_spacing / 2])
            translate([x, 0, 0])
                rotate([90, 0, 0])
                    cylinder(h = splice_size[1] + 2 * boolean_overlap,
                        d = splice_hole_diameter, center = true);
    }
}

function crossmember_joint_rail_x(index) = index == 1
    ? crossmember_x[index] - crossmember_joint_rail_x_offset
    : frame_rear_x - crossmember_joint_rail_x_offset;
function crossmember_joint_cross_y(index) = index == 1
    ? rail_center_y - crossmember_joint_cross_inset_y
    : rail_center_y;

module crossmember(index = 0) {
    assert(index >= 0 && index < len(crossmember_x));
    member_width = index == 1 ? crossmember_inner_width : frame_outer_width;
    difference() {
        translate([crossmember_x[index], 0,
                frame_bottom_z + crossmember_size[2] / 2])
            cube([crossmember_size[0], member_width,
                crossmember_size[2]], center = true);
        if (index == 0)
            for (side = [-1, 1])
                translate([crossmember_x[index],
                        side * crossmember_bolt_offset_y,
                        frame_bottom_z + crossmember_size[2] / 2])
                    cylinder(h = crossmember_size[2] + 2 * boolean_overlap,
                        d = crossmember_bolt_diameter, center = true);
        else
            for (side = [-1, 1])
                translate([crossmember_x[index],
                        side * crossmember_joint_cross_y(index),
                        frame_bottom_z + crossmember_size[2] / 2])
                    cylinder(h = crossmember_size[2] + 2 * boolean_overlap,
                        d = crossmember_bolt_diameter, center = true);

        for (side = [-1, 1])
            translate([crossmember_x[index], side * 12,
                    frame_bottom_z + crossmember_size[2] / 2])
                cylinder(h = crossmember_size[2] + 2 * boolean_overlap,
                    d = m3_clearance, center = true);

        for (support_x = side_support_x)
            if (crossmember_x[index] == support_x)
                for (side = [-1, 1])
                    for (hole_y = [-support_receiver_mount_hole_spacing / 2,
                            support_receiver_mount_hole_spacing / 2])
                        translate([crossmember_x[index],
                                side * side_support_y + hole_y,
                                frame_bottom_z + crossmember_size[2] / 2])
                            cylinder(h = crossmember_size[2]
                                    + 2 * boolean_overlap,
                                d = m3_clearance, center = true);

        if (crossmember_x[index] == rear_accessory_x) {
            for (side = [-1, 1])
                for (offset_z = [-rear_light_mount_spacing_z / 2,
                        rear_light_mount_spacing_z / 2])
                    translate([rear_accessory_x,
                            side * rear_light_y,
                            frame_bottom_z + crossmember_size[2] / 2
                                + offset_z])
                        rotate([0, 90, 0])
                            cylinder(h = crossmember_size[0]
                                    + 2 * boolean_overlap,
                                d = rear_accessory_hole_diameter,
                                center = true);
            for (offset_y = [-license_plate_hole_spacing_y / 2,
                    license_plate_hole_spacing_y / 2])
                translate([rear_accessory_x,
                        license_plate_center_y + offset_y,
                        frame_bottom_z + crossmember_size[2] / 2])
                    rotate([0, 90, 0])
                        cylinder(h = crossmember_size[0]
                                + 2 * boolean_overlap,
                            d = rear_accessory_hole_diameter, center = true);
        }
    }
}

module crossmember_export(index = 0) {
    translate([-crossmember_x[index], 0,
            -(frame_bottom_z + crossmember_size[2] / 2)])
        crossmember(index);
}

module crossmember_joint_plate(index = 1, side = 1, face = 1) {
    assert(index == 1 || index == 2);
    rail_point = [crossmember_joint_rail_x(index), side * rail_center_y];
    cross_point = [crossmember_x[index],
        side * crossmember_joint_cross_y(index)];
    plate_z = face > 0
        ? frame_bottom_z + rail_size[2]
            + crossmember_joint_plate_thickness / 2
        : frame_bottom_z - crossmember_joint_plate_thickness / 2;
    difference() {
        hull()
            for (point = [rail_point, cross_point])
                translate([point[0], point[1], plate_z])
                    cylinder(h = crossmember_joint_plate_thickness,
                        d = crossmember_joint_plate_boss_diameter,
                        center = true);
        for (point = [rail_point, cross_point])
            translate([point[0], point[1], plate_z])
                cylinder(h = crossmember_joint_plate_thickness
                        + 2 * boolean_overlap,
                    d = crossmember_bolt_diameter, center = true);
    }
}

module crossmember_joint_plate_export(index = 1) {
    rail_point = [crossmember_joint_rail_x(index), rail_center_y];
    cross_point = [crossmember_x[index], crossmember_joint_cross_y(index)];
    center = [(rail_point[0] + cross_point[0]) / 2,
        (rail_point[1] + cross_point[1]) / 2];
    translate([-center[0], -center[1],
            -(frame_bottom_z + rail_size[2])])
        crossmember_joint_plate(index, 1, 1);
}

module beam_between_xy(a, b, width, height, z) {
    length = norm([b[0] - a[0], b[1] - a[1]]);
    angle = atan2(b[1] - a[1], b[0] - a[0]);
    translate([(a[0] + b[0]) / 2, (a[1] + b[1]) / 2, z])
        rotate([0, 0, angle])
            cube([length, width, height], center = true);
}


module v_bridge(x) {
    bridge_width = 2 * v_half_width_at(x);
    difference() {
        translate([x, 0, frame_bottom_z + crossmember_size[2] / 2])
            cube([crossmember_size[0], bridge_width, crossmember_size[2]],
                center = true);
        if (x == winch_bridge_x)
            translate([x, 0,
                    frame_bottom_z + crossmember_size[2] / 2])
                cylinder(h = crossmember_size[2]
                        + 2 * boolean_overlap,
                    d = m3_clearance, center = true);
        if (x == v_front_roller_x)
            for (side = [-1, 1])
                translate([x, side * 12,
                        frame_bottom_z + crossmember_size[2] / 2])
                    cylinder(h = crossmember_size[2]
                            + 2 * boolean_overlap,
                        d = m3_clearance, center = true);
    }
}

module drawbar_center_beam() {
    difference() {
        beam_between_xy(
            [v_apex_x - boolean_overlap, 0],
            [winch_bridge_x + boolean_overlap, 0],
            drawbar_beam_width, drawbar_beam_height,
            frame_bottom_z + drawbar_beam_height / 2);
        for (hole_x = [coupler_adapter_center_x
                    + coupler_frame_hole_first_x,
                coupler_adapter_center_x + coupler_frame_hole_first_x
                    + coupler_frame_hole_spacing])
            translate([hole_x, 0,
                    frame_bottom_z + drawbar_beam_height / 2])
                cylinder(h = drawbar_beam_height
                        + 2 * boolean_overlap,
                    d = coupler_frame_hole_diameter, center = true);
        for (side = [-1, 1])
            translate([winch_brace_lower_x, side * winch_brace_mount_y,
                    frame_bottom_z + drawbar_beam_height / 2])
                cylinder(h = drawbar_beam_height + 2 * boolean_overlap,
                    d = m3_clearance, center = true);
    }
}

module v_joint_holes() {
    for (side = [-1, 1])
        for (hole_x = [v_split_x - v_joint_hole_spacing / 2,
                v_split_x + v_joint_hole_spacing / 2])
            translate([hole_x, side * v_half_width_at(hole_x),
                    frame_bottom_z + drawbar_beam_height / 2])
                cylinder(h = drawbar_beam_height + 2 * boolean_overlap,
                    d = v_joint_hole_diameter, center = true);
}

module v_joint_half_relief(remove_top = false) {
    relief_height = drawbar_beam_height / 2
        + v_joint_lap_clearance / 2 + 2 * boolean_overlap;
    relief_z = remove_top
        ? frame_bottom_z + drawbar_beam_height
            - relief_height / 2 + boolean_overlap
        : frame_bottom_z + relief_height / 2 - boolean_overlap;
    for (side = [-1, 1])
        beam_between_xy(
            [v_split_x - v_joint_overlap - boolean_overlap,
                side * v_half_width_at(v_split_x - v_joint_overlap
                    - boolean_overlap)],
            [v_split_x + v_joint_overlap + boolean_overlap,
                side * v_half_width_at(v_split_x + v_joint_overlap
                    + boolean_overlap)],
            drawbar_beam_width + 2 * boolean_overlap,
            relief_height, relief_z);
}

module coupler_tongue_relief() {
    tongue_start_x = coupler_adapter_center_x
        + coupler_adapter_size[0] / 2 - boolean_overlap;
    tongue_end_x = tongue_start_x + coupler_tongue_length
        + 2 * boolean_overlap;
    relief_height = drawbar_beam_height / 2
        + coupler_lap_clearance / 2 + 2 * boolean_overlap;
    translate([(tongue_start_x + tongue_end_x) / 2, 0,
            frame_bottom_z + relief_height / 2 - boolean_overlap])
        cube([tongue_end_x - tongue_start_x,
            drawbar_beam_width + 2 * fit_clearance,
            relief_height], center = true);
}

module drawbar_front() {
    difference() {
        union() {
            for (side = [-1, 1])
                beam_between_xy(
                    [v_apex_x, 0],
                    [v_split_x + v_joint_overlap,
                        side * v_half_width_at(v_split_x + v_joint_overlap)],
                    drawbar_beam_width, drawbar_beam_height,
                    frame_bottom_z + drawbar_beam_height / 2);
            drawbar_center_beam();
            v_bridge(winch_bridge_x);
        }
        v_joint_holes();
        v_joint_half_relief(false);
        coupler_tongue_relief();
        // Cut after the complete V/front union so the converging V arms
        // cannot fill the adapter bolt holes again.
        for (hole_x = [coupler_adapter_center_x
                    + coupler_frame_hole_first_x,
                coupler_adapter_center_x + coupler_frame_hole_first_x
                    + coupler_frame_hole_spacing])
            translate([hole_x, 0,
                    frame_bottom_z + drawbar_beam_height / 2])
                cylinder(h = drawbar_beam_height + 2 * boolean_overlap,
                    d = coupler_frame_hole_diameter, center = true);
    }
}

module drawbar_rear() {
    difference() {
        intersection() {
            union() {
                for (side = [-1, 1])
                    beam_between_xy(
                        [v_split_x - v_joint_overlap,
                            side * v_half_width_at(v_split_x - v_joint_overlap)],
                        [v_rear_x, side * rail_center_y],
                        drawbar_beam_width, drawbar_beam_height,
                        frame_bottom_z + drawbar_beam_height / 2);
                v_bridge(v_front_roller_x);
            }
            translate([(v_split_x - v_joint_overlap + v_frame_end_x) / 2,
                    0, frame_bottom_z + drawbar_beam_height / 2])
                cube([v_frame_end_x - (v_split_x - v_joint_overlap),
                    frame_outer_width + 2 * drawbar_beam_width,
                    drawbar_beam_height + 2 * boolean_overlap], center = true);
        }
        v_joint_holes();
        v_joint_half_relief(true);
        for (side = [-1, 1])
            translate([v_rail_joint_front_x,
                    side * v_half_width_at(v_rail_joint_front_x),
                    frame_bottom_z + drawbar_beam_height / 2])
                cylinder(h = drawbar_beam_height + 2 * boolean_overlap,
                    d = crossmember_bolt_diameter, center = true);
    }
}

module v_rail_joint_plate(side = 1, face = 1) {
    plate_z = face > 0
        ? frame_bottom_z + drawbar_beam_height
            + v_rail_joint_plate_thickness / 2
        : frame_bottom_z - v_rail_joint_plate_thickness / 2;
    joint_points = [
        [v_rail_joint_front_x,
            side * v_half_width_at(v_rail_joint_front_x)],
        [v_rear_x, side * rail_center_y],
        [v_rail_joint_rear_x, side * rail_center_y]
    ];

    difference() {
        hull()
            for (point = joint_points)
                translate([point[0], point[1], plate_z])
                    cylinder(h = v_rail_joint_plate_thickness,
                        d = v_rail_joint_plate_diameter, center = true);
        for (point = joint_points)
            translate([point[0], point[1], plate_z])
                cylinder(h = v_rail_joint_plate_thickness
                        + 2 * boolean_overlap,
                    d = crossmember_bolt_diameter, center = true);
    }
}

module v_rail_joint_plate_export() {
    translate([-v_rear_x, -rail_center_y,
            -(frame_bottom_z + drawbar_beam_height
                + v_rail_joint_plate_thickness / 2)])
        v_rail_joint_plate(1, 1);
}

module drawbar() {
    drawbar_front();
    drawbar_rear();
}

module assembled_frame() {
    for (index = [1 : 2])
        for (side = [-1, 1])
            rail_segment(index, side);
    for (index = [0 : len(crossmember_x) - 1])
        crossmember(index);
    for (seam_x = [2 * frame_segment_length])
        for (side = [-1, 1])
            translate([seam_x,
                    side * rail_center_y
                        + side * splice_plate_offset_y,
                    frame_center_z])
                splice_plate();
    drawbar();
    for (side = [-1, 1])
        for (face = [-1, 1]) {
            v_rail_joint_plate(side, face);
            for (index = [1 : len(crossmember_x) - 1])
                crossmember_joint_plate(index, side, face);
        }
}

