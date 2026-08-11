// Simplified purchased-component reference from the official Savox drawing.
// Origin: output-spline centre at the top of the 36.95 mm assembly height.

function savox_sw0250_body_size() = [29.5, 14, 32.5];
function savox_sw0250_flange_size() = [40, 20.5, 2];
function savox_sw0250_hole_spacing() = 35.3;
function savox_sw0250_output_from_end() = 9;
function savox_sw0250_body_center_from_output() =
    savox_sw0250_body_size()[0] / 2
        - savox_sw0250_output_from_end();
function savox_sw0250_flange_from_bottom() = 23.85;
function savox_sw0250_total_height() = 36.95;
function savox_sw0250_mount_hole_x() = [
    savox_sw0250_body_center_from_output()
        - savox_sw0250_hole_spacing() / 2,
    savox_sw0250_body_center_from_output()
        + savox_sw0250_hole_spacing() / 2
];

module savox_sw0250mg_reference() {
    body = savox_sw0250_body_size();
    flange = savox_sw0250_flange_size();
    body_bottom_z = -savox_sw0250_total_height();
    flange_z = body_bottom_z + savox_sw0250_flange_from_bottom();

    color([0.10, 0.45, 0.90, 0.78]) {
        translate([
            savox_sw0250_body_center_from_output(),
            0,
            body_bottom_z + body[2] / 2
        ])
            cube(body, center = true);

        difference() {
            translate([
                savox_sw0250_body_center_from_output(),
                0,
                flange_z
            ])
                cube(flange, center = true);

            for (hole_x = savox_sw0250_mount_hole_x())
                translate([hole_x, 0, flange_z])
                    cylinder(h = flange[2] + 1,
                        d = 2.4, center = true, $fn = 24);
        }

        translate([0, 0, -3.2])
            cylinder(h = 6.4, d = 10, center = true, $fn = 36);
        cylinder(h = 3, d = 6, center = true, $fn = 30);
    }
}
