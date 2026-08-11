include <config.scad>
use <outboard_xl_audit_preview.scad>
use <outboard_xl_extension.scad>

show_original_lower_unit = true;

reference_tubes();
reference_v_transom();

color([0.90, 0.76, 0.12]) {
    positioned_vendor_upper();
    positioned_mount0();
}

if (show_original_lower_unit)
    color([0.90, 0.15, 0.12, 0.28])
        positioned_vendor_lower();

color([0.22, 0.48, 0.82, 0.78])
    positioned_xl_extension();

color([0.92, 0.08, 0.12])
    positioned_xl_fastener_guides();

color([0.88, 0.68, 0.10])
    positioned_vendor_lower(required_leg_extension);

color([0.1, 0.8, 0.3, 0.45])
    translate([0, 0, target_cavitation_z])
        cube([120, 245, 1], center = true);

echo("XL_LEG_EXTENSION_MM", required_leg_extension);
echo("SHAFT_CLEARANCE_MM", xl_extension_shaft_clearance);
echo("LONGER_DRIVE_SHAFT_REQUIRED_MM", required_leg_extension);
