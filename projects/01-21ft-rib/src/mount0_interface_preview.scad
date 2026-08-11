include <config.scad>
use <outboard_adapter.scad>

// Set to zero to bring the adapter face into nominal contact.
inspection_gap = 5;

mount0_interface_check(explode = inspection_gap);
