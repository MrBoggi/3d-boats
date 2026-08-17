include <config.scad>
use <../../01-21ft-rib/scad/hull.scad>
use <../../01-21ft-rib/scad/stern.scad>
use <../../01-21ft-rib/scad/outboard_xl_adapter.scad>
use <../../01-21ft-rib/scad/bow_eye.scad>
use <../../01-21ft-rib/scad/hull_geometry.scad>

module boat_outboard_reference() {
    color([0.95, 0.35, 0.08])
        translate([stern_motor_mount_x(), 0, 0])
            positioned_mount0();

    translate([stern_motor_body_x(), stern_motor_body_y(), 0]) {
        color([0.90, 0.76, 0.12])
            positioned_vendor_upper();
        color([0.88, 0.68, 0.10])
            positioned_vendor_lower(0);
    }
}

module boat_bow_eye_reference() {
    translate([0, 0, boat_z_offset]) bow_eye_assembly();
}

module boat_bow_hull_reference() {
    translate([0, 0, boat_z_offset]) stage5_bow_section();
}

module boat_bow_stop_contact_reference() {
    boat_hull_wall = 2.8;
    translate([0, 0, boat_z_offset])
        difference() {
            union()
                for (i = [0 : 1])
                    hull() {
                        stage4_v_station(i);
                        stage4_v_station(i + 1);
                    }
            union()
                for (i = [0 : 1])
                    hull() {
                        stage4_v_station(i,
                            inset = boat_hull_wall,
                            raised_keel = boat_hull_wall * 1.8,
                            raised_chine = 10);
                        stage4_v_station(i + 1,
                            inset = boat_hull_wall,
                            raised_keel = boat_hull_wall * 1.8,
                            raised_chine = 10);
                    }
        }
}

module boat_hull_reference() {
    translate([0, 0, boat_z_offset]) {
        stage5_bow_section();
        stage5_mid_section();
        stage5_stern_section();
    }
}

module boat_outboard_clearance_envelope() {
    translate([0, 0, boat_z_offset])
        translate([stern_motor_body_x(), stern_motor_body_y(), 0])
            positioned_vendor_envelope();
}

module boat_outboard_global_reference() {
    translate([0, 0, boat_z_offset]) boat_outboard_reference();
}

module boat_reference() {
    color([0.15, 0.35, 0.55, 0.28])
        boat_hull_reference();
    boat_bow_eye_reference();
    translate([0, 0, boat_z_offset]) {
        if (show_outboard)
            boat_outboard_reference();
    }
}

module boat_side_contact_slices() {
    color([1.0, 0.35, 0.05, 0.90])
        for (station_x = side_support_x)
            intersection() {
                translate([0, 0, boat_z_offset]) {
                    stage5_bow_section();
                    stage5_mid_section();
                    stage5_stern_section();
                }
                translate([station_x, 0, boat_z_offset + 45])
                    cube([1.5, boat_beam + 4, 100], center = true);
            }
}

module boat_keel_contact_slices() {
    color([0.05, 0.85, 0.95, 0.88])
        for (station_x = keel_roller_x)
            intersection() {
                translate([0, 0, boat_z_offset]) {
                    stage5_bow_section();
                    stage5_mid_section();
                    stage5_stern_section();
                }
                translate([station_x, 0, boat_z_offset + 45])
                    cube([1.5, boat_beam + 4, 100], center = true);
            }
}

module boat_clearance_envelope() {
    color([0.9, 0.2, 0.2, 0.12])
        translate([boat_length / 2, 0,
                boat_z_offset + 55])
            cube([
                boat_length,
                boat_beam + 2 * boat_hard_clearance,
                110
            ], center = true);
}

