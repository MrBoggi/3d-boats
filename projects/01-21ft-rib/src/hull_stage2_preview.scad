include <config.scad>
use <hull_stage2.scad>
use <outboard_adapter.scad>

show_mount0 = false;

color([0.12, 0.14, 0.17])
    union() {
        stage2_rigid_hull_shell();
        stage2_transom();
    }

color([0.98, 0.62, 0.02])
    stage2_pontoon_shells();

if (show_mount0)
    color([0.82, 0.52, 0.08])
        translate(mount0_vendor_center)
            mount0_vendor_reference();
