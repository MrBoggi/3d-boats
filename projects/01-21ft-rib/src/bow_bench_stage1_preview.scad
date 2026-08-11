include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>
use <console_stage1.scad>
use <helm_bench_stage1.scad>
use <aft_bench_stage1.scad>
use <bow_bench_stage1.scad>

color([0.12, 0.14, 0.17, 0.34])
    stage4_pontoon_shells();
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
bow_bench_stage1_assembly();
