include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>

// Exact CGAL check for the complete forward structural envelope.
union() {
    stage4_forward_structure();
    cockpit_floor_fixed();
    cockpit_floor_support_rails();
}
