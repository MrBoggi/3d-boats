// 1:10 tandem-axle trailer for project 01-21ft-rib. Dimensions in mm.
// Coordinates: X bow->stern, Y port->starboard, Z ground->up.

project_scale_denominator = 10;
quality = $preview ? 28 : 72;
boolean_overlap = 0.2;
fit_clearance = 0.3;
printer_size = [256, 256, 256];

boat_length = 660;
boat_beam = 252;
boat_z_offset = 56;
boat_hard_clearance = 5;

trailer_front_x = -140;
trailer_rear_x = 660;
ground_z = 0;
road_size = [900, 420, 2];
road_center_x = (trailer_front_x + trailer_rear_x) / 2;
road_edge_line_width = 4;
road_edge_line_inset = 18;
frame_front_x = 0;
frame_rear_x = 585;
frame_segment_length = 220;
frame_outer_width = 220;
rail_size = [frame_segment_length, 12, 18];
rail_center_y = frame_outer_width / 2 - rail_size[1] / 2;
frame_bottom_z = 22;
frame_center_z = frame_bottom_z + rail_size[2] / 2;
crossmember_size = [12, frame_outer_width, 18];
crossmember_x = [270, 430, 585];
rear_accessory_x = 585;
rear_light_y = 106;
rear_light_housing_size = [8, 38, 20];
rear_light_lens_size = [3, 34, 16];
rear_light_mount_spacing_z = 13;
rear_light_lens_hole_spacing_y = 24;
rear_light_lens_clearance_hole = 2.2;
rear_light_lens_pilot_hole = 1.6;
rear_accessory_hole_diameter = 2.4;
license_plate_center_y = 52;
license_plate_size = [3, 42, 16];
license_plate_hole_spacing_y = 28;

splice_length = 45;
splice_size = [splice_length, 7, 11];
splice_hole_diameter = 3.4;
splice_hole_spacing = 26;
splice_plate_offset_y = rail_size[1] / 2 + splice_size[1] / 2;
crossmember_bolt_offset_y = rail_center_y;
crossmember_bolt_diameter = 3.4;

track_width = 290;
wheel_diameter = 65;
wheel_width = 27;
wheel_hub_diameter = 20;
wheel_rim_diameter = 47;
wheel_rim_width = 16;
wheel_tire_clearance = 0.35;
wheel_spoke_count = 6;
wheel_spoke_width = 5;
wheel_axle_hole = 4.3;
wheel_axle_diameter = 4;
wheel_axle_length = 55;
wheel_axle_head_af = 7;
wheel_axle_head_depth = 4;
wheel_hex_af = 12;
wheel_hex_depth = 5.5;
wheel_hex_fit_clearance = 0.25;
wheel_hex_flange_diameter = 18;
wheel_hex_flange_thickness = 2;
wheel_adapter_sleeve_diameter = 10;
wheel_axial_clearance = 0.2;
wheel_nut_af = 7;
wheel_nut_thickness = 4;
wheel_washer_thickness = 0.8;
wheel_washer_count = 2;
bogie_center_x = 470;
bogie_axle_spacing = 78;
bogie_arm_length = 98;
bogie_arm_height = 18;
bogie_arm_thickness = 8;
bogie_clevis_ear_thickness = 4;
bogie_clevis_arm_clearance = 1.2;
bogie_clevis_rail_overlap = 1;
bogie_clevis_top_bridge_height = 4;
bogie_clevis_top_bridge_clearance = 1;
bogie_clevis_mount_pad_size = [34, 14, 4];
bogie_center_y = frame_outer_width / 2
    + bogie_clevis_ear_thickness - bogie_clevis_rail_overlap
    + bogie_clevis_arm_clearance + bogie_arm_thickness / 2;
bogie_pivot_z = frame_center_z;
wheel_axis_z = wheel_diameter / 2;
bogie_pivot_hole = 3.4;
bogie_pivot_washer_diameter = 7;
bogie_pivot_washer_thickness = 0.8;
bogie_pivot_nut_af = 5.5;
bogie_pivot_nut_thickness = 2.6;
bogie_pivot_bolt_head_diameter = 5.5;
bogie_pivot_bolt_head_thickness = 3;
bogie_pivot_bolt_length = 18;
bogie_stop_angle = 12;
bogie_stop_pin_diameter = 4;
bogie_stop_pin_radius = 17;
bogie_stop_contact_radius = bogie_arm_height / 2
    + bogie_stop_pin_diameter / 2;
bogie_stop_pin_height_adjustment = 1.5;
bogie_stop_pin_z_offset = (bogie_stop_contact_radius
    + bogie_stop_pin_radius * sin(bogie_stop_angle))
    / cos(bogie_stop_angle) + bogie_stop_pin_height_adjustment;
bogie_mount_size = [34,
    2 * bogie_clevis_ear_thickness + bogie_arm_thickness
        + 2 * bogie_clevis_arm_clearance, 36];
bogie_clevis_top_z = bogie_pivot_z + bogie_mount_size[2] / 2
    + bogie_clevis_top_bridge_clearance;
bogie_mount_hole_spacing = 20;
bogie_mount_fastener_length = rail_size[2]
    + bogie_clevis_mount_pad_size[2] + 6;
wheel_arm_to_wheel_gap = track_width / 2 - wheel_width / 2
    - bogie_center_y - bogie_arm_thickness / 2;
wheel_adapter_sleeve_length = wheel_arm_to_wheel_gap
    - wheel_hex_flange_thickness - wheel_washer_thickness;
wheel_axle_required_length = bogie_arm_thickness
    + wheel_arm_to_wheel_gap
    + wheel_width + wheel_axial_clearance
    + wheel_nut_thickness + wheel_washer_count * wheel_washer_thickness;

fender_width = 35;
fender_thickness = 2.4;
// Clearance includes wheel-centre movement at full bogie tilt plus 2 mm.
bogie_wheel_center_rise = bogie_axle_spacing / 2 * sin(bogie_stop_angle)
    + (wheel_axis_z - bogie_pivot_z) * cos(bogie_stop_angle)
    - (wheel_axis_z - bogie_pivot_z);
fender_running_clearance = 2;
fender_radial_clearance = ceil(bogie_wheel_center_rise
    + fender_running_clearance);
fender_axial_clearance = 2;
fender_inner_y = track_width / 2 - wheel_width / 2
    - fender_axial_clearance - fender_thickness;
fender_center_y = fender_inner_y + fender_width / 2;
fender_back_outer_y = fender_inner_y + fender_thickness;
fender_bracket_clevis_inset = 4;
fender_bracket_bed_clearance = 0.2;
fender_bracket_inner_y = bogie_center_y - fender_bracket_clevis_inset;
fender_bracket_size = [10, fender_inner_y - fender_bracket_inner_y, 4];
fender_bracket_center_y = (fender_bracket_inner_y + fender_inner_y) / 2;
fender_bracket_z = bogie_clevis_top_z + fender_bracket_bed_clearance
    + fender_bracket_size[2] / 2;
fender_bracket_flange_thickness = 4;
fender_mount_hole_local_z = wheel_diameter / 2
    + fender_radial_clearance + fender_thickness / 2;
fender_bracket_flange_height = wheel_axis_z
    + fender_mount_hole_local_z - fender_bracket_z + 3;
fender_bracket_rail_hole_y = bogie_center_y;
fender_bracket_hole_local_z = wheel_axis_z
    + fender_mount_hole_local_z - fender_bracket_z;
fender_mount_hole_diameter = 3.4;

keel_roller_x = [110, 270, 430, 585];
keel_roller_local_keel_z = [28.9917, 3.2742, 0, 0];
keel_roller_keel_z = [for (keel_z = keel_roller_local_keel_z)
    boat_z_offset + keel_z];
keel_roller_width = 32;
keel_roller_center_diameter = 7;
keel_roller_end_diameter = 23;
keel_roller_center_clearance = 0.5;
keel_roller_axial_clearance = 1;
keel_roller_beam_clearance = 0.4;
keel_roller_v_angle = 26;
keel_roller_axle_z = [for (keel_z = keel_roller_keel_z)
    keel_z - keel_roller_center_diameter / 2
        - keel_roller_center_clearance];
keel_roller_profile_stations = [
    [-16, 11.5], [-13, 10], [-8, 7.4], [-3, 4.4],
    [0, 3.5], [3, 4.4], [8, 7.4], [13, 10], [16, 11.5]
];
keel_roller_profile_clearances = [
    for (station = keel_roller_profile_stations)
        tan(keel_roller_v_angle) * abs(station[0])
            + keel_roller_center_diameter / 2
            + keel_roller_center_clearance - station[1]
];
keel_roller_axle_hole = 3.2;
roller_bracket_wall = 4;
keel_roller_bracket_arm_y = keel_roller_width / 2
    + keel_roller_axial_clearance + roller_bracket_wall / 2;
keel_roller_bracket_foot_width = 8;
keel_roller_bracket_hole_y = keel_roller_width / 2
    + keel_roller_axial_clearance
    + keel_roller_bracket_foot_width / 2;

side_roller_diameter = 16;
side_roller_end_diameter = 13;
side_roller_profile_stations = [
    [-9, 6.5], [-6, 7.2], [0, 8], [6, 7.2], [9, 6.5]
];
side_roller_width = 18;
side_roller_axle_hole = 3.2;
side_roller_spacing_x = 32;
side_roller_cradle_size = [48, 26, 8];
side_roller_holder_size = [12, 26, 5];
side_roller_holder_lug_wall = 4;
side_roller_holder_pivot_hole = 3.2;
side_roller_holder_pivot_z = 3;
side_roller_holder_mount_z = 6.7;
side_roller_holder_axis_z = 13;
side_roller_wobble_limit = 10;
side_roller_work_angles = [[0, 0], [0, 0]];
side_roller_debug_angles = [[-6, 6], [-6, 6]];
side_roller_stop_width = 5;
side_roller_stop_height = 7;
side_roller_stop_foot_height = 2;
side_roller_stop_clearance = 0.5;

side_support_x = [270, 430];
side_support_y = 70;
side_support_angle = 26;
side_support_work_clearance = 8;
side_support_debug_clearance = 12;
side_support_local_keel_z = [4.13265, 0.021999];
side_support_end_keel_z = [[4.13265, 2.46492], [0.021999, 0]];
side_support_pitch = [
    for (end_z = side_support_end_keel_z)
        atan2(end_z[1] - end_z[0], side_roller_spacing_x)
];
side_support_roller_axis_z = side_roller_holder_mount_z
    + side_roller_holder_axis_z;
side_support_top_z = [
    for (keel_z = side_support_local_keel_z)
        boat_z_offset + keel_z
            + tan(side_support_angle) * side_support_y
            - (side_roller_diameter / 2 + side_support_work_clearance
                + side_support_roller_axis_z)
                / cos(side_support_angle)
];
support_post_size = [10, 10];
support_pad_size = [42, 16, 5];
support_adjustment_hole = 3.4;
support_receiver_size = [16, 16, 24];
support_receiver_mount_size = [16, 34, 4];
support_receiver_mount_hole_spacing = 24;
support_receiver_wall = 3;
support_adjustment_pitch = 8;
support_adjustment_count = 3;
support_pad_pivot_hole = 3.2;
support_pad_bracket_width = 20;
drawbar_beam_width = 12;
v_split_x = 60;
v_rear_x = 270;
v_front_roller_x = 110;
v_frame_end_x = v_rear_x - crossmember_size[0] / 2;
rail_front_x = v_rear_x + crossmember_size[0] / 2;
v_rail_joint_plate_thickness = 3;
v_rail_joint_plate_diameter = 14;
v_rail_joint_front_x = v_rear_x - 22;
v_rail_joint_rear_x = v_rear_x + 22;
v_joint_hole_diameter = 3.4;
v_joint_hole_spacing = 10;
v_joint_overlap = 10;
winch_bridge_x = 34;
drawbar_beam_height = 18;
coupler_size = [32, 24, 14];
coupler_adapter_size = coupler_size;
coupler_adapter_center_x = trailer_front_x
    + coupler_adapter_size[0] / 2;
coupler_axis_z = frame_bottom_z + coupler_adapter_size[2] / 2;
coupler_m3_clearance = 3.4;
coupler_bolt_head_af = 5.5;
coupler_bolt_head_depth = 3;
coupler_stud_diameter = 3;
coupler_stud_projection = 9;
coupler_tongue_length = 18;
coupler_tongue_size = [coupler_tongue_length, 12, drawbar_beam_height];
coupler_frame_hole_spacing = 8;
coupler_frame_hole_first_x = coupler_adapter_size[0] / 2 + 6;
coupler_frame_hole_diameter = 3.4;
coupler_ball_diameter = 6;
coupler_ball_clearance = 0.3;
coupler_claw_length = 35;
coupler_claw_body_diameter = 8;
coupler_claw_outer_diameter = 14;
v_apex_x = trailer_front_x + coupler_size[0] - 2;
function v_half_width_at(x) =
    rail_center_y * (x - v_apex_x) / (v_rear_x - v_apex_x);
winch_x = 34;
winch_post_size = [12, 18, 100];
winch_post_base = [winch_bridge_x, frame_bottom_z + drawbar_beam_height];
winch_post_top = [-2, 108];
winch_axis_x = 1;
winch_axis_z = 99;
winch_seat_size = [36, 28, 5];
winch_brace_lower_x = -8;
winch_brace_upper = [18, 70];
winch_brace_size = 6;
winch_brace_mount_y = 3;
winch_drum_diameter = 22;
winch_drum_width = 20;
winch_drum_flange_diameter = 28;
winch_crank_radius = 24;
winch_handle_diameter = 6;
winch_mount_hole_spacing = 20;
bow_stop_center = [24, 0, 124];
bow_stop_size = [20, 18, 9];
bow_stop_arm_width = 4;
bow_stop_mount_hub_diameter = 9;
bow_stop_mount_hub_width = 7;
bow_stop_v_vertex = [6, 0, 0];
bow_stop_v_tip = [18, 9, -3];
bow_stop_work_angle = 10;
bow_stop_pivot_limit = 15;
bow_stop_pivot_clearance = 0.4;
bow_stop_fork_ear_thickness = 3;
bow_stop_fork_boss_diameter = 11.5;
bow_stop_fork_root_x = bow_stop_center[0] - 9;
bow_stop_pivot_stack_width = bow_stop_mount_hub_width
    + 2 * (bow_stop_pivot_clearance + bow_stop_fork_ear_thickness);
bow_stop_pivot_washer_diameter = 7;
bow_stop_pivot_washer_thickness = 0.8;
bow_stop_pivot_nut_af = 5.5;
bow_stop_pivot_nut_thickness = 2.6;

bow_eye_center = [42, 0, 109.55];
bow_eye_outer_diameter = 10;
bow_eye_inner_diameter = 5;
bow_eye_width = 3;
bow_eye_mount_size = [9, 8, 3];
winch_strap_width = 2.5;
winch_strap_envelope_width = 3.5;
winch_strap_thickness = 0.6;
winch_strap_envelope_thickness = 1;
winch_hook_outer_diameter = 8;
winch_hook_inner_diameter = 5;
winch_hook_width = 3;
winch_strap_start = [winch_axis_x + winch_drum_diameter / 2, 0,
    winch_axis_z];
winch_strap_end = [bow_eye_center[0] - winch_hook_outer_diameter / 2,
    0, bow_eye_center[2]];

m3_clearance = 3.4;
m3_nut_envelope = [6.2, 5.5, 2.6];

selected_part = "assembly";
show_boat = true;
show_hardware = false;
show_coupler_reference = true;
show_outboard = true;
show_road = true;
show_keel_contact_debug = false;
show_side_contact_debug = false;

$fn = quality;

assert(frame_segment_length <= printer_size[0]);
assert(frame_outer_width <= printer_size[1]);
assert(wheel_diameter <= printer_size[0]);
assert(bogie_axle_spacing > wheel_diameter,
    "Bogie wheels overlap");
assert(bogie_stop_pin_z_offset > bogie_stop_contact_radius,
    "Bogie stop pins must clear the arm in neutral position");
assert(bogie_clevis_arm_clearance > bogie_pivot_washer_thickness,
    "Clevis gap must leave running clearance around pivot washers");
assert(bogie_clevis_top_bridge_clearance < bogie_clevis_top_bridge_height,
    "Clevis top bridge must still overlap both ears");
assert(bogie_pivot_bolt_length >= bogie_mount_size[1]
        - bogie_pivot_nut_thickness / 2,
    "M3 bogie pivot bolt is too short for clevis and captive nut");
assert(track_width / 2 - wheel_width / 2 > boat_beam / 2,
    "Wheels do not clear the boat beam");
assert(frame_rear_x == rear_accessory_x,
    "Main rails must terminate at the rear accessory crossmember");
assert(v_apex_x < v_split_x && v_split_x < v_rear_x,
    "V-frame stations must increase from coupler to rear joint");
assert(v_frame_end_x < v_rear_x && rail_front_x > v_rear_x,
    "V and rail ends must meet opposite faces of the front crossmember");
assert(v_joint_hole_spacing + v_joint_hole_diameter
        <= 2 * v_joint_overlap,
    "Two V-joint bolts do not fit inside the overlap");
assert(v_rail_joint_front_x < v_rear_x
        && v_rail_joint_rear_x > v_rear_x,
    "V-to-rail joint plate must bridge the front crossmember");
assert(splice_length > splice_hole_spacing + 2 * splice_hole_diameter,
    "Splice plate has insufficient edge distance");
assert(wheel_rim_diameter < wheel_diameter);
assert(wheel_hex_af - 2 * wheel_hex_fit_clearance > wheel_axle_hole,
    "Hex adapter wall is too thin");
assert(bogie_axle_spacing - wheel_diameter
        >= fender_bracket_size[0] + 2 * fit_clearance,
    "Centre fender bracket does not clear the tandem wheels");
assert(fender_radial_clearance >= 3,
    "Fender radial clearance is too small");
assert(fender_radial_clearance >= bogie_wheel_center_rise
        + fender_running_clearance,
    "Fender does not clear a wheel at full bogie travel");
assert(fender_back_outer_y <= track_width / 2 - wheel_width / 2
        - fender_axial_clearance,
    "Fender back plate intrudes into the wheel envelope");
assert(wheel_adapter_sleeve_length > 0,
    "Wheel adapter sleeve has no room between bogie arm and wheel");
assert(wheel_axle_length >= wheel_axle_required_length,
    "M4 wheel screw is too short for arm, wheel, washers and nut");
assert(coupler_ball_diameter >= 5.8 && coupler_ball_diameter <= 6.0,
    "Selected trailer claw must match a 5.8-6.0 mm tow ball");
assert(coupler_tongue_length > coupler_frame_hole_first_x
        + coupler_frame_hole_spacing - coupler_adapter_size[0] / 2,
    "Coupler tongue is too short for both frame bolts");
assert(winch_post_top[0] < winch_post_base[0],
    "Winch post must lean toward the trailer front");
assert(bow_stop_center[0] > winch_axis_x,
    "Bow stop must be on the boat side of the winch drum");
assert(abs(bow_stop_work_angle) <= bow_stop_pivot_limit,
    "Bow stop work angle exceeds its pivot limit");
assert(bow_stop_pivot_clearance >= fit_clearance,
    "Bow stop hub has insufficient axial clearance in its fork");
assert((bow_stop_fork_boss_diameter - m3_clearance) / 2 >= 4,
    "Bow stop fork has insufficient material around its pivot hole");
assert(bow_eye_outer_diameter > bow_eye_inner_diameter + 2,
    "Bow eye has insufficient material around its opening");
assert(winch_strap_envelope_width >= winch_strap_width
        && winch_strap_envelope_thickness >= winch_strap_thickness,
    "Winch strap reserve must contain the nominal strap");
assert(winch_hook_outer_diameter <= 8
        && winch_hook_width <= 3,
    "Winch hook exceeds the reserved purchase envelope");
assert(winch_strap_end[0] > winch_strap_start[0],
    "Winch strap must run from the drum toward the boat");
assert(winch_strap_end[2] < bow_stop_center[2],
    "Bow eye and strap must remain below the bow stop pivot");
assert(winch_brace_lower_x < winch_brace_upper[0]
        && winch_brace_lower_x < winch_post_top[0],
    "Winch braces must land on the coupling side of the post");
assert(support_receiver_size[0] > support_post_size[0]
        + 2 * fit_clearance);
assert(keel_roller_end_diameter > keel_roller_center_diameter,
    "Keel roller must have a concave V profile");
assert(keel_roller_profile_stations[0][1]
            == keel_roller_end_diameter / 2
        && keel_roller_profile_stations[4][1]
            == keel_roller_center_diameter / 2,
    "V roller profile endpoints must match its named diameters");
assert(min(keel_roller_profile_clearances) >= 0.2,
    "V roller profile penetrates the analytical 26-degree hull bottom");
assert(len(keel_roller_axle_z) == len(keel_roller_x),
    "Every keel roller station needs a measured axle height");
assert(min(keel_roller_axle_z) > frame_bottom_z + crossmember_size[2],
    "Keel roller axle collides with its mounting beam");
assert(min(keel_roller_axle_z) - keel_roller_end_diameter / 2
        >= frame_bottom_z + crossmember_size[2]
            + keel_roller_beam_clearance,
    "Keel roller rotational envelope collides with its mounting beam");
assert(keel_roller_bracket_arm_y - roller_bracket_wall / 2
        >= keel_roller_width / 2 + keel_roller_axial_clearance,
    "Keel roller ends collide with holder side arms");
assert(fender_bracket_size[1] > fender_mount_hole_diameter
        + 2 * fit_clearance,
    "Fender bracket has insufficient clevis-top footprint");
assert(side_support_top_z[1] > frame_bottom_z + crossmember_size[2]
        + support_receiver_wall,
    "Side support post has no height above its mounted receiver");
assert(abs(side_support_angle - keel_roller_v_angle) < 0.001,
    "Side roller axes must follow the hull deadrise");
assert(min(side_support_top_z) > frame_bottom_z + crossmember_size[2]
        + support_receiver_wall,
    "Hull-derived side support pivot is below its receiver");
assert(side_roller_wobble_limit >= max([for (angles = side_roller_debug_angles) for (angle = angles) abs(angle)]),
    "Wobble debug angle exceeds its mechanical stop");
assert(len(side_support_pitch) == len(side_support_x),
    "Every side support needs a hull-derived longitudinal pitch");
assert(side_support_debug_clearance >= side_support_work_clearance,
    "Side support debug clearance must not be smaller than work clearance");
assert(side_roller_holder_axis_z > side_roller_diameter / 2,
    "Wobble roller collides with its secondary pivot");
assert(side_roller_holder_mount_z - side_roller_holder_size[2] / 2
        > side_roller_cradle_size[2] / 2,
    "Wobble holder overlaps the main cradle in neutral position");
assert(side_roller_diameter > side_roller_end_diameter,
    "Side wobble roller must have a convex barrel profile");
assert(side_roller_profile_stations[0][1]
            == side_roller_end_diameter / 2
        && side_roller_profile_stations[2][1]
            == side_roller_diameter / 2,
    "Side roller profile must match its named diameters");
assert(side_roller_spacing_x > side_roller_holder_size[0]
        + 2 * fit_clearance,
    "Adjacent wobble holders overlap");

