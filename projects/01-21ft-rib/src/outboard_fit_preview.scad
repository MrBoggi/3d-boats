include <config.scad>
use <hull.scad>
use <outboard_adapter.scad>

show_vendor_outboard = true;

color([0.12, 0.14, 0.17]) {
    hull_bow();
    hull_mid();
    hull_stern();
}

color([0.98, 0.62, 0.02])
    pontoons();

rib_outboard_adapter_envelope();
rib_outboard_reference(show_vendor = show_vendor_outboard);
