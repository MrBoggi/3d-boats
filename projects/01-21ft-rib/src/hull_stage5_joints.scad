include <hull_stage4.scad>

joint_profile_slice = 0.8;

stage5_joint_design_locked = true;

assert(stage5_joint_design_locked,
    "Stage 5 hull joints must remain locked after owner approval");
assert(section_bow_end == 220 && section_mid_end == 430,
    "Approved Stage 5 section planes changed");
assert(joint_land == 8 && glue_gap == 0.25,
    "Approved Stage 5 key length or fit clearance changed");
assert(joint_bulkhead_thickness == 3
        && joint_socket_back_wall == 2.8
        && joint_socket_wall == 2.8,
    "Approved Stage 5 bulkhead or socket wall changed");
assert(joint_center_key_yz == [12, 10]
        && joint_side_key_yz == [8, 5]
        && joint_side_key_y == 48
        && joint_key_lead_in == 0.6,
    "Approved Stage 5 alignment-key geometry changed");

assert(section_bow_end + joint_land <= printer_x,
    "Bow section plus alignment keys exceeds Bambu A1 X capacity");
assert(section_mid_end - section_bow_end + joint_land <= printer_x,
    "Middle section plus alignment keys exceeds Bambu A1 X capacity");
assert(boat_length - section_mid_end <= printer_x,
    "Stern section exceeds Bambu A1 X capacity");
assert(joint_land > joint_key_lead_in,
    "Alignment-key lead-in must be shorter than the key");
assert(joint_center_key_yz[0] > 2 * joint_key_lead_in
        && joint_center_key_yz[1] > 2 * joint_key_lead_in,
    "Centre key becomes non-positive at its lead-in");
assert(joint_side_key_yz[0] > 2 * joint_key_lead_in
        && joint_side_key_yz[1] > 2 * joint_key_lead_in,
    "Side key becomes non-positive at its lead-in");
assert(joint_socket_back_wall >= wall_thickness,
    "Blind socket back wall must not be thinner than the hull wall");

function stage5_key_size_yz(key_y) =
    abs(key_y) < 0.01 ? joint_center_key_yz : joint_side_key_yz;

function stage5_key_center_z(seam_x, key_y) =
    let(
        surface_z = stage4_v_surface_z_at(seam_x, key_y),
        chine_z = stage4_v_value_at(seam_x, stage4_chine_z)
    )
    (surface_z + chine_z) / 2;

module stage5_forward_outer_envelope() {
    union() {
        stage4_v_outer();
        for (side = [-1, 1])
            stage4_tube_side(side);
        stage4_bow_bridge();
        stage4_pontoon_hull_saddles();
    }
}

module stage5_joint_profile_local(seam_x) {
    source_x = min(seam_x - joint_profile_slice / 2,
        section_mid_end - joint_profile_slice / 2);

    translate([-source_x, 0, 0])
        intersection() {
            stage5_forward_outer_envelope();
            translate([source_x, 0, 65])
                cube([joint_profile_slice, printer_y, 150], center = true);
        }
}

module stage5_joint_bulkhead(seam_x, section_side) {
    bulkhead_center_x = seam_x
        + section_side * joint_bulkhead_thickness / 2;

    translate([bulkhead_center_x, 0, 0])
        scale([joint_bulkhead_thickness / joint_profile_slice, 1, 1])
            stage5_joint_profile_local(seam_x);
}

module stage5_alignment_key(seam_x, key_y) {
    key_size = stage5_key_size_yz(key_y);
    key_z = stage5_key_center_z(seam_x, key_y);

    hull() {
        translate([seam_x + boolean_overlap, key_y, key_z])
            cube([2 * boolean_overlap, key_size[0], key_size[1]],
                center = true);
        translate([seam_x + joint_land - joint_key_lead_in / 2,
                key_y, key_z])
            cube([
                joint_key_lead_in,
                key_size[0] - 2 * joint_key_lead_in,
                key_size[1] - 2 * joint_key_lead_in
            ], center = true);
    }
}

module stage5_alignment_keys(seam_x) {
    for (key_y = [-joint_side_key_y, 0, joint_side_key_y])
        stage5_alignment_key(seam_x, key_y);
}

module stage5_socket_housing(seam_x, key_y) {
    key_size = stage5_key_size_yz(key_y);
    housing_length = joint_land + joint_socket_back_wall;
    key_z = stage5_key_center_z(seam_x, key_y);

    translate([seam_x + housing_length / 2, key_y, key_z])
        cube([
            housing_length,
            key_size[0] + 2 * joint_socket_wall,
            key_size[1] + 2 * joint_socket_wall
        ], center = true);
}

module stage5_socket_cutter(seam_x, key_y) {
    key_size = stage5_key_size_yz(key_y);
    key_z = stage5_key_center_z(seam_x, key_y);

    translate([seam_x + joint_land / 2 - boolean_overlap,
            key_y, key_z])
        cube([
            joint_land + 2 * boolean_overlap,
            key_size[0] + 2 * glue_gap,
            key_size[1] + 2 * glue_gap
        ], center = true);
}

module stage5_socket_housings(seam_x) {
    for (key_y = [-joint_side_key_y, 0, joint_side_key_y])
        stage5_socket_housing(seam_x, key_y);
}

module stage5_socket_cutters(seam_x) {
    for (key_y = [-joint_side_key_y, 0, joint_side_key_y])
        stage5_socket_cutter(seam_x, key_y);
}

module stage5_bow_section() {
    union() {
        stage4_bow_section();
        stage5_joint_bulkhead(section_bow_end, -1);
        stage5_alignment_keys(section_bow_end);
    }
}

module stage5_mid_section() {
    difference() {
        union() {
            stage4_mid_section();
            stage5_joint_bulkhead(section_bow_end, 1);
            stage5_socket_housings(section_bow_end);
            stage5_joint_bulkhead(section_mid_end, -1);
            stage5_alignment_keys(section_mid_end);
        }
        stage5_socket_cutters(section_bow_end);
    }
}

module stage5_stern_section() {
    difference() {
        union() {
            stage4_stern_section();
            stage5_joint_bulkhead(section_mid_end, 1);
            stage5_socket_housings(section_mid_end);
        }
        stage5_socket_cutters(section_mid_end);
    }
}
