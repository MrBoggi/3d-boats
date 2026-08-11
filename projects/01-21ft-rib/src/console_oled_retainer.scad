include <config.scad>
use <console_stage1.scad>

// Print flat; the X-axis thickness is rotated onto the printer Z-axis.
rotate([0, 90, 0])
    console_oled_retainer_part();
