include <config.scad>

// Presentation-only road surface. Its top face is Z=0, tangent to the tires.
module road_reference() {
    color([0.16, 0.17, 0.18])
        translate([road_center_x, 0, ground_z - road_size[2] / 2])
            cube(road_size, center = true);

    for (side = [-1, 1])
        color([0.82, 0.82, 0.76])
            translate([road_center_x,
                    side * (road_size[1] / 2 - road_edge_line_inset),
                    ground_z + 0.05])
                cube([road_size[0], road_edge_line_width, 0.1], center = true);
}
