include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>

// Structural verification view: unlike the furniture preview, this includes
// the V-bottom and the pontoon-to-hull saddles that the floor must overlap.
union() {
    stage4_complete_structure();
    cockpit_floor_fixed();
    cockpit_floor_support_rails();
}
