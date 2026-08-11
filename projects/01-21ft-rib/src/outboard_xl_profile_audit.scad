include <config.scad>
include <../../../shared/components/outboards/printables_1191848.scad>

// Orthographic vendor-profile measurement at the native extension interface.
// Export as SVG with profile_part="upper" or "lower".
profile_part = "upper";
profile_z_native = 323.75;

module native_upper_parts() {
    outboard_1191848_part("lowerbody_02.stl");
    outboard_1191848_part("motormount_watercooled_03.stl");
}

module native_lower_parts() {
    outboard_1191848_part("transmcase_back_01.stl");
    outboard_1191848_part("transmcase_front_03.stl");
    outboard_1191848_part("verticalspacer_02.stl");
}

projection(cut = true)
    translate([0, 0, -profile_z_native])
        if (profile_part == "upper")
            native_upper_parts();
        else if (profile_part == "lower")
            native_lower_parts();
        else
            assert(false, str("Unknown profile_part: ", profile_part));
