include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>
use <../../../shared/components/servos/savox_sw0250mg.scad>

show_hull = true;
show_support_rails = true;
show_component_envelopes = false;
show_print_boundaries = false;

if (show_hull)
    color([0.12, 0.14, 0.17, 0.42])
        stage4_complete_structure();

color([0.66, 0.68, 0.71])
    cockpit_floor_fixed();
color([0.66, 0.68, 0.71])
    floor_battery_lid();
color([0.66, 0.68, 0.71])
    floor_aft_lid();

if (show_support_rails)
    color([0.25, 0.28, 0.32])
        cockpit_floor_support_rails();

if (show_component_envelopes) {
    floor_stage1_component_envelopes();

    color([0.05, 0.45, 0.95, 0.70])
        translate(steering_servo_axis)
            rotate([0, 0, steering_servo_rotation_z])
                savox_sw0250mg_reference();
}

// Optional debug planes identify hidden print boundaries.
if (show_print_boundaries)
    color([0.05, 0.65, 0.95, 0.35])
        for (seam_x = [section_bow_end, section_mid_end])
            translate([seam_x, 0, cockpit_floor_z])
                cube([0.8, reference_beam + 4, 80], center = true);
