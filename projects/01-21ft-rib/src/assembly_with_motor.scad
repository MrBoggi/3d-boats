// Presentation-only complete assembly. The included assembly renders the
// approved boat; the vendor outboard is added with the locked Stage 3 datums.
include <assembly.scad>
use <stern_stage3.scad>
use <outboard_xl_extension.scad>

show_mount0 = true;
show_outboard = true;

module approved_outboard_assembly_reference() {
    if (show_mount0)
        color([0.95, 0.35, 0.08])
            translate([stern_motor_mount_x(), 0, 0])
                positioned_mount0();

    if (show_outboard)
        translate([stern_motor_body_x(), stern_motor_body_y(), 0]) {
            color([0.90, 0.76, 0.12])
                positioned_vendor_upper();
            color([0.88, 0.68, 0.10])
                positioned_xl_extension();
            color([0.88, 0.68, 0.10])
                positioned_vendor_lower(required_leg_extension);
        }
}

approved_outboard_assembly_reference();
