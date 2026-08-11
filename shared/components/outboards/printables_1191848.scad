// Unmodified third-party reference wrapper.
// Source: https://www.printables.com/model/1191848-rc-outboard-motor-110
// License reported by source: CC BY-NC-ND. Do not modify or redistribute derivatives.

vendor_dir = "../../../vendor/printables-1191848/rc-outboard-motor-110-model_files/";

// Recenter the original shared CAD coordinates around the reference assembly.
outboard_1191848_origin = [200, -400, 350.5];
outboard_1191848_envelope_size = [100, 70, 166];

module outboard_1191848_part(filename) {
    import(str(vendor_dir, filename), convexity = 10);
}

module outboard_1191848_reference(include_mount = false, mount_variant = 0, front_variant = 3) {
    translate(-outboard_1191848_origin) {
        outboard_1191848_part("cover_02.stl");
        outboard_1191848_part("lowerbody_02.stl");
        outboard_1191848_part("motormount_watercooled_03.stl");
        outboard_1191848_part("transmcase_back_01.stl");
        outboard_1191848_part(
            front_variant == 2
                ? "transmcase_front_02.stl"
                : "transmcase_front_03.stl"
        );
        outboard_1191848_part("verticalspacer_02.stl");
        if (include_mount)
            outboard_1191848_part(
                mount_variant == -3
                    ? "enginemount_-3_01.stl"
                    : "enginemount_0_01.stl"
            );
    }
}

module outboard_1191848_mount_reference(mount_variant = 0) {
    mount_center = mount_variant == -3
        ? [249.775, -447.515, 341.22]
        : [273.185, -424.205, 341.325];

    translate(-mount_center)
        outboard_1191848_part(
            mount_variant == -3
                ? "enginemount_-3_01.stl"
                : "enginemount_0_01.stl"
        );
}

module outboard_1191848_envelope() {
    color([0.12, 0.45, 0.85, 0.35])
        cube(outboard_1191848_envelope_size, center = true);
}
