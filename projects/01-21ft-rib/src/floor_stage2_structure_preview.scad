include <config.scad>
use <hull_stage4.scad>
use <floor_stage2_supports.scad>

// F6 target: supports must overlap the locked hull structure physically.
union() {
    stage4_complete_structure();
    floor_stage2_internal_structure();
}
