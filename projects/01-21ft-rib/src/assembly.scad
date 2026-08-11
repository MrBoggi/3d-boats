include <config.scad>
include <hull_stage5_joints.scad>
use <hardware.scad>
use <ladder.scad>
use <console_stage1.scad>
use <helm_bench_stage1.scad>
use <aft_bench_stage1.scad>
use <bow_bench_stage1.scad>
use <floor_stage1.scad>
use <outboard_xl_extension.scad>

module assembled_rib() {
    color([0.12, 0.14, 0.17]) {
        stage5_bow_section();
        stage5_mid_section();
        stage5_stern_section();
    }

    color([0.64, 0.66, 0.69])
        cockpit_floor_fixed();
    color([0.80, 0.82, 0.84])
        floor_battery_lid();
    color([0.76, 0.78, 0.80])
        floor_aft_lid();

    color([0.48, 0.50, 0.53])
        console_shell_stage1();
    console_dashboard_controls_reference();
    color([0.25, 0.80, 0.95, 0.32])
        console_windshield_panel_reference();
    color([0.04, 0.05, 0.06])
        console_windshield_hoop_part();

    helm_bench_stage1_assembly();
    aft_bench_stage1_assembly();
    bow_bench_stage1_assembly();

    if (show_hardware)
        hardware_envelopes();
}

if (selected_part == "assembly")
    assembled_rib();
else if (selected_part == "hull_stage5_bow")
    stage5_bow_section();
else if (selected_part == "hull_stage5_mid")
    stage5_mid_section();
else if (selected_part == "hull_stage5_stern")
    stage5_stern_section();
else if (selected_part == "console_helm")
    console_shell_stage1();
else if (selected_part == "helm_bench_cushion")
    helm_bench_cushion_part();
else if (selected_part == "helm_bench_frame_port")
    helm_bench_side_frame_part(-1);
else if (selected_part == "helm_bench_frame_starboard")
    helm_bench_side_frame_part(1);
else if (selected_part == "helm_bench_cross_braces")
    helm_bench_cross_braces_part();
else if (selected_part == "helm_bench_side_rails")
    helm_bench_side_rails_part();
else if (selected_part == "aft_bench_servo_cover")
    aft_bench_servo_cover_part();
else if (selected_part == "aft_bench_cushion")
    aft_bench_cushion_part();
else if (selected_part == "aft_bench_backrest")
    aft_bench_backrest_part();
else if (selected_part == "aft_bench_seat_support")
    aft_bench_seat_support_part();
else if (selected_part == "aft_bench")
    aft_bench_stage1_assembly();
else if (selected_part == "bow_locker_base")
    bow_bench_locker_base_part();
else if (selected_part == "bow_cushion")
    bow_bench_cushion_part();
else if (selected_part == "bow_rail_port")
    bow_single_rail_side_part(-1);
else if (selected_part == "bow_rail_starboard")
    bow_single_rail_side_part(1);
else if (selected_part == "bow_anchor_roller")
    bow_anchor_roller_part();
else if (selected_part == "bow_bench")
    bow_bench_stage1_assembly();
else if (selected_part == "cockpit_floor_fixed")
    cockpit_floor_fixed();
else if (selected_part == "floor_battery_lid")
    floor_battery_lid();
else if (selected_part == "floor_aft_lid")
    floor_aft_lid();
else if (selected_part == "windshield_frame")
    console_windshield_hoop_part();
else if (selected_part == "ladder")
    ladder();
else if (selected_part == "hardware_debug")
    hardware_envelopes();
else if (selected_part == "console_stage1")
    console_shell_stage1();
else if (selected_part == "console_oled_retainer")
    rotate([0, 90, 0])
        console_oled_retainer_part();
else if (selected_part == "outboard_xl_adapter")
    xl_leg_extension_export();
else
    assert(false, str("Unknown selected_part: ", selected_part));
