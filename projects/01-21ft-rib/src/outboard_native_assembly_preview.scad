include <config.scad>
use <../../../shared/components/outboards/printables_1191848.scad>

// Diagnostic only: preserve every vendor STL in its original coordinate system.
color([0.88, 0.72, 0.12])
    outboard_1191848_reference(include_mount = true, mount_variant = 0);
