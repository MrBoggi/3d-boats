include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>
use <floor_stage2_supports.scad>
use <console_stage1.scad>
use <helm_bench_stage1.scad>

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
color([0.25, 0.80, 0.95, 0.28])
    console_windshield_panel_reference();
color([0.04, 0.05, 0.06])
    console_windshield_hoop_part();

helm_bench_stage1_assembly();

// Brass cylinders show the four proposed M2 heat-set insert locations.
color([0.82, 0.55, 0.16])
    helm_bench_floor_insert_references();
