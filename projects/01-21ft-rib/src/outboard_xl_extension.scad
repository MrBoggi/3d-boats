include <config.scad>
include <../../../shared/components/outboards/printables_1191848.scad>

extension_axis_native = [198.774, -386.290];
extension_interface_z_native = 323.75;
extension_shaft_clearance = xl_extension_shaft_clearance;

// Half-profile sampled from the largest boundary loop on the original
// transmission-case mating surface, relative to the measured shaft axis.
xl_adapter_half_profile = [
    [0.000, -39.639], [5.481, -38.274], [9.653, -34.511],
    [11.370, -31.258], [12.495, -27.053], [13.986, -18.364],
    [14.886, -8.197], [15.614, 1.317], [15.871, 8.005],
    [15.379, 9.897], [14.729, 11.538], [13.767, 13.855],
    [12.465, 16.950], [10.111, 19.657], [8.071, 20.958],
    [5.989, 22.632], [4.995, 23.604], [4.535, 23.825],
    [3.355, 23.950], [1.572, 24.048], [0.000, 24.079]
];
xl_adapter_profile = concat(
    xl_adapter_half_profile,
    [for (i = [len(xl_adapter_half_profile) - 2 : -1 : 1])
        [-xl_adapter_half_profile[i][0], xl_adapter_half_profile[i][1]]]);

assert(xl_adapter_shaft_tube_diameter > extension_shaft_clearance
        + 2 * xl_adapter_wall,
    "XL adapter shaft tube leaves insufficient wall");
assert(len(xl_adapter_curve_fractions) == len(xl_adapter_curve_offsets),
    "XL adapter curve tables must have equal length");
assert(xl_adapter_curve_fractions[0] == 0
        && xl_adapter_curve_fractions[len(xl_adapter_curve_fractions) - 1] == 1,
    "XL adapter curve must span both mating faces");

module vendor_upper_reference() {
    translate(-outboard_1191848_origin) {
        outboard_1191848_part("cover_02.stl");
        outboard_1191848_part("lowerbody_02.stl");
        outboard_1191848_part("motormount_watercooled_03.stl");
    }
}

module vendor_lower_reference(drop = 0) {
    translate(-outboard_1191848_origin)
        translate([0, 0, -drop]) {
            outboard_1191848_part("transmcase_back_01.stl");
            outboard_1191848_part("transmcase_front_03.stl");
            outboard_1191848_part("verticalspacer_02.stl");
        }
}

module xl_adapter_footprint_2d() {
    polygon(points = xl_adapter_profile);
}

module xl_adapter_station_native(z, profile_offset) {
    translate([extension_axis_native[0], extension_axis_native[1], z])
        linear_extrude(height = xl_adapter_station_height)
            offset(delta = profile_offset)
                xl_adapter_footprint_2d();
}

module xl_adapter_curved_loft_native(
        extension = required_leg_extension,
        inset = 0,
        bottom_inset = 0,
        top_inset = 0) {
    bottom_z = extension_interface_z_native - extension + bottom_inset;
    usable_height = extension - bottom_inset - top_inset
        - xl_adapter_station_height;

    for (i = [0 : len(xl_adapter_curve_fractions) - 2])
        hull() {
            xl_adapter_station_native(
                bottom_z + usable_height * xl_adapter_curve_fractions[i],
                xl_adapter_curve_offsets[i] - inset);
            xl_adapter_station_native(
                bottom_z + usable_height * xl_adapter_curve_fractions[i + 1],
                xl_adapter_curve_offsets[i + 1] - inset);
        }
}

module xl_adapter_outer_native(extension = required_leg_extension) {
    xl_adapter_curved_loft_native(extension);
}

module xl_adapter_structure_native(extension = required_leg_extension) {
    bottom_z = extension_interface_z_native - extension;
    union() {
        difference() {
            xl_adapter_outer_native(extension);
            xl_adapter_curved_loft_native(
                extension = extension,
                inset = xl_adapter_wall,
                bottom_inset = xl_adapter_face_thickness,
                top_inset = xl_adapter_face_thickness);
        }

        translate([extension_axis_native[0], extension_axis_native[1],
                bottom_z])
            cylinder(h = extension, d = xl_adapter_shaft_tube_diameter);

        for (center = xl_adapter_bolt_centers)
            translate([extension_axis_native[0] + center[0],
                    extension_axis_native[1] + center[1], bottom_z])
                cylinder(h = extension, d = xl_adapter_bolt_boss_diameter);
    }
}

module xl_leg_extension_native(
        extension = required_leg_extension,
        shaft_clearance = extension_shaft_clearance) {
    difference() {
        xl_adapter_structure_native(extension);

        translate([extension_axis_native[0], extension_axis_native[1],
                extension_interface_z_native - extension
                    - boolean_overlap])
            cylinder(h = extension
                    + 2 * boolean_overlap, d = shaft_clearance);

        for (center = xl_adapter_bolt_centers)
            translate([extension_axis_native[0] + center[0],
                    extension_axis_native[1] + center[1],
                    extension_interface_z_native - extension
                        - boolean_overlap])
                cylinder(h = extension
                        + 2 * boolean_overlap,
                    d = xl_adapter_bolt_clearance);
    }
}

module xl_leg_extension_export() {
    translate([-extension_axis_native[0], -extension_axis_native[1],
            -(extension_interface_z_native - required_leg_extension)])
        xl_leg_extension_native();
}

module xl_leg_extension_reference() {
    translate(-outboard_1191848_origin)
        xl_leg_extension_native();
}

module positioned_mount0() {
    translate([0, 0, mount_center_z])
        rotate([0, mount0_transom_tilt_correction, 0])
            rotate([0, 0, -90])
                outboard_1191848_mount_reference(0);
}

module positioned_vendor_upper() {
    translate([0, 0, mount_center_z])
        rotate([0, motor_mount_tilt_correction, 0])
            translate([0, 0, assembly_origin_above_mount])
                rotate([0, 0, -90])
                    vendor_upper_reference();
}

module positioned_vendor_lower(drop = 0) {
    translate([0, 0, mount_center_z])
        rotate([0, motor_mount_tilt_correction, 0])
            translate([0, 0, assembly_origin_above_mount])
                rotate([0, 0, -90])
                    vendor_lower_reference(drop);
}

module xl_adapter_fastener_guides_native(extension = required_leg_extension) {
    for (center = xl_adapter_bolt_centers)
        translate([extension_axis_native[0] + center[0],
                extension_axis_native[1] + center[1],
                extension_interface_z_native - extension - 3])
            cylinder(h = extension + 6, d = 2.4);
}

module positioned_xl_fastener_guides() {
    translate([0, 0, mount_center_z])
        rotate([0, motor_mount_tilt_correction, 0])
            translate([0, 0, assembly_origin_above_mount])
                rotate([0, 0, -90])
                    translate(-outboard_1191848_origin)
                        xl_adapter_fastener_guides_native();
}

module positioned_xl_extension() {
    translate([0, 0, mount_center_z])
        rotate([0, motor_mount_tilt_correction, 0])
            translate([0, 0, assembly_origin_above_mount])
                rotate([0, 0, -90])
                    xl_leg_extension_reference();
}
