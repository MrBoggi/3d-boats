include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>
use <floor_stage2_supports.scad>
use <console_stage1.scad>
use <helm_bench_stage1.scad>
use <aft_bench_stage1.scad>
use <bow_bench_stage1.scad>
use <../../../shared/components/servos/savox_sw0250mg.scad>

show_internal_structure = false;
show_component_envelopes = false;
show_console_references = true;

color([0.12, 0.14, 0.17, show_internal_structure ? 0.38 : 1.0])
    stage4_complete_structure();

color([0.64, 0.66, 0.69])
    cockpit_floor_fixed();
color([0.80, 0.82, 0.84])
    floor_battery_lid();
color([0.76, 0.78, 0.80])
    floor_aft_lid();

if (show_internal_structure)
    color([0.20, 0.23, 0.27, 0.72])
        floor_stage2_internal_structure();

color([0.48, 0.50, 0.53])
    console_shell_stage1();

if (show_console_references) {
    console_dashboard_controls_reference();
    color([0.25, 0.80, 0.95, 0.32])
        console_windshield_panel_reference();
    color([0.04, 0.05, 0.06])
        console_windshield_hoop_part();
}

helm_bench_stage1_assembly();
aft_bench_stage1_assembly();
bow_bench_stage1_assembly();

if (show_component_envelopes) {
    floor_stage1_component_envelopes();
    aft_bench_servo_clearance_reference();
    color([0.05, 0.45, 0.95, 0.70])
        translate(steering_servo_axis)
            rotate([0, 0, steering_servo_rotation_z])
                savox_sw0250mg_reference();
}
