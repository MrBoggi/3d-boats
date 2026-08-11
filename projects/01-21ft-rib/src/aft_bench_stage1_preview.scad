include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>
use <console_stage1.scad>
use <helm_bench_stage1.scad>
use <aft_bench_stage1.scad>
use <../../../shared/components/servos/savox_sw0250mg.scad>

color([0.12, 0.14, 0.17, 0.34])
    stage4_complete_structure();
color([0.64, 0.66, 0.69])
    cockpit_floor_fixed();
color([0.80, 0.82, 0.84])
    floor_battery_lid();
color([0.76, 0.78, 0.80])
    floor_aft_lid();

color([0.48, 0.50, 0.53])
    console_shell_stage1();
helm_bench_stage1_assembly();
aft_bench_stage1_assembly();

aft_bench_servo_clearance_reference();
color([0.05, 0.45, 0.95, 0.70])
    translate(steering_servo_axis)
        rotate([0, 0, steering_servo_rotation_z])
            savox_sw0250mg_reference();
color([0.82, 0.55, 0.16])
    aft_bench_insert_references();
