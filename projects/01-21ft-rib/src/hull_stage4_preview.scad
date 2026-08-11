include <config.scad>
include <hull_stage4.scad>
use <stern_stage3.scad>

show_section_seams = true;

color([0.12, 0.14, 0.17]) {
    stage4_v_shell();
    stage4_pontoon_hull_saddles();
    stage4_bow_v_cap();
    stern_v_shell();
    stern_pontoon_hull_saddles();
    stern_keel_spine();
    stern_cockpit_transition();
    stern_transom();
}

color([0.98, 0.62, 0.02]) {
    stage4_pontoon_shells();
    stern_pontoon_shells();
}

if (show_section_seams)
    color([0.05, 0.65, 0.95, 0.45])
        for (seam_x = [section_bow_end, section_mid_end])
            translate([seam_x, 0, 65])
                cube([0.8, reference_beam + 4, 130], center = true);
