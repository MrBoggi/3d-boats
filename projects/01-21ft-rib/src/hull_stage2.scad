include <config.scad>
use <hull.scad>
use <outboard_adapter.scad>

// Step 2 candidate: exterior geometry only.
module stage2_rigid_hull_shell() {
    difference() {
        lofted_v_hull();
        lofted_v_hull(
            inset = wall_thickness,
            raised_keel = wall_thickness * 1.8,
            top_extra = 12);
    }
}

module stage2_pontoon_shells() {
    union() {
        difference() {
            pontoons();
            pontoons(radius_delta = wall_thickness);
        }

        // Watertight tube closures at the exposed stern ends.
        for (side = [-1, 1])
            pontoon_stern_cap(side);
    }
}

module stage2_transom() {
    transom_width = 126;
    transom_height = 56;
    transom_center_z = 36;
    transom_thickness = 14;
    transom_aft_x = 630;

    difference() {
        union() {
            translate([
                transom_aft_x - transom_thickness / 2,
                0,
                transom_center_z
            ])
                cube([
                    transom_thickness,
                    transom_width,
                    transom_height
                ], center = true);

            // Local reinforced pad; aft face is flush with the transom.
            // Pontoon ends continue 10 mm farther aft.
            translate(mount0_adapter_center)
                cube(mount0_adapter_plate_size, center = true);
        }

        translate(mount0_adapter_center) {
            mount0_hole_pattern(length = transom_thickness + 4);
            rotate([0, 90, 0])
                cylinder(
                    h = transom_thickness + 4,
                    d = mount0_center_clearance_diameter,
                    center = true);
        }
    }
}

module stage2_exterior_hull() {
    union() {
        stage2_rigid_hull_shell();
        stage2_pontoon_shells();
        stage2_transom();
    }
}
