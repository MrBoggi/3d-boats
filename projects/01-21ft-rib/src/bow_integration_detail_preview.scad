include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>
use <bow_bench_stage1.scad>

// Focused bow verification: colors expose every structural interface.
color([0.78, 0.68, 0.38, 0.34])
    stage4_pontoon_shells();
color([0.10, 0.12, 0.15])
    stage4_v_shell();
color([0.22, 0.25, 0.29])
    stage4_pontoon_hull_saddles();
color([0.68, 0.70, 0.74])
    cockpit_floor_fixed();
color([0.52, 0.54, 0.57])
    bow_bench_locker_base_part();
color([0.88, 0.89, 0.90])
    bow_bench_cushion_part();
color([0.03, 0.04, 0.05])
    bow_railing_assembly_reference();
