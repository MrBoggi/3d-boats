include <config.scad>
use <hull_stage4.scad>
use <floor_stage1.scad>

section_x = 70;
section_thickness = 1.2;

// Y/Z section through the joined pontoon, fairing, V-shell and rising floor.
intersection() {
    union() {
        stage4_forward_structure();
        cockpit_floor_fixed();
        cockpit_floor_support_rails();
    }
    translate([section_x, 0, 75])
        cube([section_thickness, printer_y, 150], center = true);
}
