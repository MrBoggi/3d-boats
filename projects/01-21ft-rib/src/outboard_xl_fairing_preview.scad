include <config.scad>
use <outboard_xl_extension.scad>

// Standalone printable-geometry check without vendor STL meshes.
color([0.88, 0.68, 0.10])
    xl_leg_extension_native();
