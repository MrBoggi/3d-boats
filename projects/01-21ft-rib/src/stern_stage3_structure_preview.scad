include <config.scad>
use <stern_stage3.scad>

check_part = "all";

if (check_part == "v") {
    stern_v_shell();
    stern_keel_spine();
}
else if (check_part == "pontoons")
    stern_pontoon_shells();
else if (check_part == "v_interface")
    union() {
        stern_v_shell();
        stern_pontoon_hull_saddles();
        stern_keel_spine();
    }
else
    stern_structure();
