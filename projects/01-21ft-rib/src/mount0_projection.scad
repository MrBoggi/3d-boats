use <../../../shared/components/outboards/printables_1191848.scad>

// Orthographic projection of mount 0 onto its broad X/Z mounting face.
// This file is diagnostic only and does not modify the vendor geometry.
projection(cut = false)
    rotate([90, 0, 0])
        outboard_1191848_mount_reference(0);
