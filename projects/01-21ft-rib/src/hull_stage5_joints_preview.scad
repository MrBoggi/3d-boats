include <hull_stage5_joints.scad>

exploded = true;
show_bulkhead_planes = true;

bow_shift = exploded ? -joint_preview_gap : 0;
stern_shift = exploded ? joint_preview_gap : 0;

color([0.86, 0.62, 0.16])
    translate([bow_shift, 0, 0])
        stage5_bow_section();

color([0.46, 0.50, 0.56])
    stage5_mid_section();

color([0.22, 0.34, 0.48])
    translate([stern_shift, 0, 0])
        stage5_stern_section();

if (show_bulkhead_planes)
    color([0.10, 0.75, 0.95, 0.30])
        for (seam_x = [section_bow_end, section_mid_end])
            translate([seam_x, 0, 65])
                cube([0.6, reference_beam + 4, 130], center = true);
