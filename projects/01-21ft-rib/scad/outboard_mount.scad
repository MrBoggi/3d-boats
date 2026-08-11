include <config.scad>
use <../../../shared/components/outboards/printables_1191848.scad>

// Mount 0 interface measured from the unmodified STL orthographic projection.
adapter_plate_size = mount0_adapter_plate_size;
adapter_edge_margin_y =
    (adapter_plate_size[1] - mount0_hole_spacing_y) / 2;
adapter_edge_margin_z =
    (adapter_plate_size[2] - mount0_hole_spacing_z) / 2;

assert(adapter_edge_margin_y >= 8,
    "Mount 0 adapter needs at least 8 mm side margin");
assert(adapter_edge_margin_z >= 8,
    "Mount 0 adapter needs at least 8 mm vertical margin");
assert(mount0_adapter_hole_diameter > mount0_vendor_hole_diameter,
    "Adapter holes must clear the vendor mount holes");

module mount0_hole_pattern(hole_diameter = mount0_adapter_hole_diameter,
        length = adapter_plate_size[0] + 2 * boolean_overlap) {
    for (y = [-mount0_hole_spacing_y / 2, mount0_hole_spacing_y / 2])
        for (z = [-mount0_hole_spacing_z / 2, mount0_hole_spacing_z / 2])
            translate([0, y, z])
                rotate([0, 90, 0])
                    cylinder(h = length, d = hole_diameter, center = true);
}

module rib_mount0_adapter_plate() {
    difference() {
        cube(adapter_plate_size, center = true);
        mount0_hole_pattern();
        rotate([0, 90, 0])
            cylinder(h = adapter_plate_size[0] + 2 * boolean_overlap,
                d = mount0_center_clearance_diameter, center = true);

    }
}


module rib_mount0_adapter_reference() {
    translate(mount0_adapter_center)
        rib_mount0_adapter_plate();
}

module mount0_vendor_reference() {
    rotate([0, 0, -90])
        outboard_1191848_mount_reference(0);
}

module mount0_interface_check(explode = 5) {
    color([0.95, 0.62, 0.12])
        mount0_vendor_reference();

    // Vendor mount spans about 17.63 mm along boat X after orientation.
    // Place the adapter on the transom side of its broad face.
    color([0.15, 0.45, 0.85, 0.65])
        translate([-(8.815 + adapter_plate_size[0] / 2 + explode), 0, 0])
            rib_mount0_adapter_plate();

    // Show the shared four-hole axes across both parts.
    color([0.9, 0.1, 0.2, 0.8])
        mount0_hole_pattern(
            hole_diameter = 1.2,
            length = 40 + explode
        );
}

// Compatibility aliases for the existing whole-boat fit preview.
module rib_outboard_adapter_envelope() {
    rib_mount0_adapter_reference();
}

module rib_outboard_reference(show_vendor = false) {
    translate(mount0_vendor_center)
        rotate([0, 0, -90])
            if (show_vendor)
                outboard_1191848_reference();
            else
                outboard_1191848_envelope();
}
