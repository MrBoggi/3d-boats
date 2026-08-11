// 21 ft RIB at 1:10 scale. All dimensions are millimetres.
// Coordinate system: X bow->stern, Y port->starboard, Z keel->up.
project_scale_denominator = 10;
boat_length = 660;
boat_width = 252;
hull_deck_z = 62;
wall_thickness = 2.8;
pontoon_radius = 25;
quality = $preview ? 28 : 72;
boolean_overlap = 0.2;

// Bambu Lab A1: keep exported bounding boxes below 256 mm per axis.
printer_x = 256;
printer_y = 256;
printer_z = 256;
section_bow_end = 220;
section_mid_end = 430;

// Assembly and glue clearances.
joint_land = 8;
glue_gap = 0.25;
fastener_clearance = 0.25;
joint_bulkhead_thickness = 3;
joint_socket_back_wall = 2.8;
joint_socket_wall = 2.8;
joint_center_key_yz = [12, 10];
joint_side_key_yz = [8, 5];
joint_side_key_y = 48;
joint_key_lead_in = 0.6;
joint_preview_gap = 12;

// Component clearance envelopes, not product dimensions.
motor_envelope = [65, 35, 45];
esc_envelope = [80, 50, 35];
servo_envelope = [42, 22, 38];
battery_envelope = [150, 50, 35];
receiver_envelope = [55, 35, 25];
ubec_envelope = [45, 25, 15];

// Selected component bodies and Stage 1 cockpit-floor clearances.
selected_battery_size = [106, 34, 22];
selected_esc_size = [60.5, 38.5, 25.6];
floor_battery_clearance = [112, 40, 28];
floor_esc_clearance = [68, 44, 31];
floor_receiver_clearance = [60, 40, 25];
cockpit_floor_z = 55;
cockpit_floor_thickness = 3;
cockpit_floor_hatch_gap = 0.3;
cockpit_floor_support_width = 5;
cockpit_floor_support_height = 4;
cockpit_floor_aft_limit = 592;
battery_hatch_center = [348, 16];
battery_hatch_size = [182, 100];

// Stage 1 console shell, mounted to the removable battery hatch.
// Each section is [Z, bow X, helm X, Y width, corner radius,
// front curvature depth].
console_sections = [
    [cockpit_floor_z, 297, 350, 84, 8, 10],
    [63, 297, 350, 84, 8, 10],
    [70, 293, 341, 74, 8, 10],
    [82, 295, 347, 72, 8, 9],
    [110, 299, 331, 70, 7, 8],
    [120, 300, 324, 70, 6, 7],
    [126, 301, 321, 70, 5, 6],
    [130, 305, 321, 70, 3, 5]
];
console_width = 82;
console_top_width = 70;
console_wall_thickness = 2.6;
console_profile_rounding = 4;
console_base_size = [53, 84, 15];
console_base_corner_radius = 8;
console_base_flange_width = 5;
console_center_y = 20;
console_port_passage_min = 44;
console_dashboard_lower = [345, 86];
console_dashboard_upper = [321, 128];
console_dashboard_width = 62;
console_dashboard_recess_lower = [342, 90];
console_dashboard_recess_upper = [322, 124];
console_dashboard_recess_width = 54;
console_dashboard_recess_corner_diameter = 6;
console_dashboard_recess_depth = 10;
console_dashboard_anchor_overlap = 4;
console_steering_wheel_diameter = 17;
console_steering_wheel_rim_diameter = 1.8;
console_throttle_size = [5.5, 9, 11]; // depth, width, height
console_throttle_panel_center = [-2, 8]; // lateral, vertical
console_oled_pcb_size = [5, 27.8, 27.3]; // depth, width, height
console_oled_active_size = [21.74, 11.2]; // width, height
console_oled_window_size = [22.5, 12];
console_oled_panel_center = [12.5, 22.5]; // lateral, vertical
console_oled_window_corner_radius = 1.2;
console_oled_mount_boss_diameter = 5.2;
console_oled_mount_pilot_diameter = 1.3; // M1.6 thread-forming screw
console_oled_mount_offsets = [16, 10]; // lateral, vertical
console_oled_retainer_thickness = 2;
console_oled_retainer_edge_overlap = 1.2;
console_oled_retainer_clearance = 0.4;
console_windshield_front_lower = [306, 130];
console_windshield_front_upper = [312, 174];
console_windshield_curve_depth = 5;
console_windshield_rear_lower = [321, 130];
console_windshield_rear_upper = [327, 174];
console_windshield_front_half_width = 34;
console_windshield_rear_half_width = 35;
console_frame_half_width = 39;
console_hoop_half_width = 38;
console_frame_diameter = 4.5;
console_screen_tab_diameter = 2.2;
console_frame_lower_anchor = [310, 78];
console_frame_shoulder = [319, 110];
console_hoop_tenon_diameter = 3.2;
console_hoop_tenon_length = 5;
console_hoop_socket_clearance = 0.3;
console_hoop_socket_boss_diameter = 7;
console_hoop_lock_pilot_diameter = 1.3;
console_design_locked = true;

// Stage 1 removable two-person helm bench.
helm_bench_center_x = 417;
helm_bench_center_y = console_center_y;
helm_bench_seat_size = [33, 88, 6];
helm_bench_seat_corner_radius = 4;
helm_bench_seat_top_z = 100;
helm_bench_frame_spacing = 80;
helm_bench_frame_thickness = 2.4;
helm_bench_tube_diameter = 2.5;
helm_bench_foot_size = [10, 8, 2];
helm_bench_foot_x_offsets = [-12, 12];
helm_bench_hatch_edge_clearance = 2;
helm_bench_floor_pilot_diameter = 2.2;
helm_bench_foot_hole_spacing_x = 4.5;
helm_bench_floor_insert_diameter = 4.0;
helm_bench_floor_insert_depth = 4.0;

// Stage 1 removable aft bench and steering-servo service cover.
aft_seat_center = [540, 0];
aft_seat_center_cushion_size = [48, 72, 7];
aft_seat_cushion_top_z = 90;
aft_seat_back_center_x = 570;
aft_seat_center_back_size = [7, 72, 30];
aft_seat_wing_back_size = [7, 22, 27];
aft_seat_back_angle = -8;
aft_seat_cover_size = [66, 74, 31];
aft_seat_cover_center = [553, 0, 70.5];
aft_seat_cover_wall = 3;
aft_seat_service_clearance = [30, 52, 27];
aft_seat_mount_x = [528, 577];
aft_seat_mount_y = [-31, 31];
aft_seat_mount_pilot_diameter = 2.2;
aft_seat_insert_diameter = 4.0;
aft_seat_insert_depth = 4.0;
aft_bench_design_locked = true;

// Stage 1 bow locker/seat and removable pontoon-following railings.
bow_bench_center_x = 87.5;
bow_bench_top_z = 90;
bow_bench_cushion_thickness = 6;
bow_bench_base_bottom_z = cockpit_floor_z;
bow_bench_base_top_z = bow_bench_top_z - bow_bench_cushion_thickness;
// The bow locker follows the rising foredeck instead of hanging below it.
bow_bench_base_forward_bottom_z = 75;
bow_bench_base_aft_bottom_z = 57.5;
bow_bench_forward_half_width = 16;
bow_bench_aft_half_width = 54;
bow_bench_forward_x = 32;
bow_bench_aft_x = 130;
bow_bench_corner_radius = 5;
bow_bench_nose_x = 25;
bow_bench_nose_radius = 7;
bow_deck_height = 7;
bow_deck_corner_radius = 2.2;
bow_rail_foot_xy = [198, 59];
// From the molded floor shoulder, across the upper-inner pontoon quadrant,
// along the pontoon sheer and finally into the anchor-roller cheek.
bow_rail_path = [
    [198, 55, 76],
    [190, 60, 84],
    [178, 67, 92],
    [160, 70, 98],
    [130, 64, 104],
    [100, 55, 109],
    [70, 43, 112],
    [45, 34, 114],
    [30, 27, 117],
    [25, 20, 118]
];
bow_rail_diameter = 2.6;
bow_rail_tenon_diameter = 2.0;
bow_rail_tenon_length = 4;
bow_rail_socket_clearance = 0.25;

// Approved Printables 1191848 Mount 0 interface.
stern_mount_design_locked = true;
mount0_hole_spacing_y = 32.69;
mount0_hole_spacing_z = 22.31;
mount0_vendor_hole_diameter = 3.28;
mount0_adapter_hole_diameter = 3.6;
mount0_center_clearance_diameter = 16;
mount0_adapter_plate_size = [8, 55, 45];
mount0_transom_tilt_correction = -5;
motor_mount_tilt_correction = -5;
mount0_mounting_face_offset = 7.366;
mount0_insert_pocket_diameter = 4.5;
mount0_insert_pocket_depth = 6.5;
mount0_boss_recess_depth = 5.5;
// Cavitation plate is nominally aligned with the stern keel at Z = 8.
mount0_adapter_center = [598, 0, 36];
mount0_vendor_center = [610.815, 0, 36];
// 21 ft RIB / XL outboard reference datums at 1:10.
reference_tube_diameter = 54;
reference_tube_top_z = 92.5;
reference_tube_center_z =
    reference_tube_top_z - reference_tube_diameter / 2;
reference_beam = 252;
reference_deadrise = 26;
reference_xl_transom_height = 63.5;
pontoon_hull_saddle_radius = 4.5;
target_cavitation_z = 0;
mount_half_height = 32.533 / 2;
mount_center_z = reference_xl_transom_height - mount_half_height;
mount_center_to_cavitation = 18.825;
mount_center_to_propeller = 45.825;
required_leg_extension =
    mount_center_z - mount_center_to_cavitation - target_cavitation_z;
assembly_origin_above_mount = 9.175;

xl_extension_shaft_clearance = 4.0;
// Measured directly from the vendor STL mating planes. The same footprint
// exists at lowerbody Z=323.745 and transmission-case Z=323.764.
xl_adapter_bolt_clearance = 3.4;
xl_adapter_bolt_centers = [
    [-7.304, -20.082],
    [ 7.304, -20.082],
    [-9.450,  11.786],
    [ 9.450,  11.786]
];
xl_adapter_wall = 2.4;
xl_adapter_station_height = 0.35;
xl_adapter_curve_fractions = [0, 0.06, 0.13, 0.25, 0.45, 0.68, 0.84, 0.94, 1];
xl_adapter_curve_offsets = [0, -0.55, -1.20, -1.55, -1.70, -1.55, -1.05, -0.35, 0];
xl_adapter_face_thickness = 3.0;
xl_adapter_bolt_boss_diameter = 7.0;
xl_adapter_shaft_tube_diameter = 9.0;
xl_adapter_design_locked = true;

shaft_tube_diameter = 8.2;
shaft_angle = 9;
steering_angle = 30;
steering_servo_axis = [547, 0, 80];
steering_arm_radius = 18;
steering_linkage_clearance = 2;
motor_steering_bolt_z = 77;
motor_steering_bolt_diameter = 2.4;
motor_steering_bolt_length = 36;
steering_servo_rotation_z = 90;
steering_servo_body_clearance = 0.75;
steering_servo_insert_pocket_diameter = 3.2;
steering_servo_insert_pocket_depth = 3.5;
steering_servo_insert_boss_diameter = 7;

// May be overridden with openscad -D 'selected_part="hull_bow"'.
selected_part = "assembly";
show_hardware = false;

$fn = quality;

assert(boat_width <= printer_y - 4,
    "Boat beam exceeds the reserved Bambu A1 side clearance");
assert(section_bow_end <= printer_x);
assert(section_mid_end - section_bow_end <= printer_x);
assert(boat_length - section_mid_end <= printer_x);
assert(cockpit_floor_z - cockpit_floor_thickness
        > floor_battery_clearance[2],
    "Cockpit floor is too low for the selected battery clearance");
assert(console_design_locked,
    "The approved console must remain locked during bench development");
assert(aft_bench_design_locked,
    "The approved aft bench must remain locked during bow-seat development");
assert(helm_bench_center_x - helm_bench_seat_size[0] / 2
        > console_sections[0][2] + 15,
    "Helm bench is too close to the locked console");
assert(helm_bench_center_x
            + max(helm_bench_foot_x_offsets)
            + helm_bench_foot_size[0] / 2
            + helm_bench_hatch_edge_clearance
        <= battery_hatch_center[0] + battery_hatch_size[0] / 2,
    "Helm bench aft feet extend beyond the removable battery hatch");
assert(helm_bench_center_y + helm_bench_frame_spacing / 2
            + helm_bench_foot_size[1] / 2
            + helm_bench_hatch_edge_clearance
        <= battery_hatch_center[1] + battery_hatch_size[1] / 2,
    "Helm bench starboard feet extend beyond the removable battery hatch");
