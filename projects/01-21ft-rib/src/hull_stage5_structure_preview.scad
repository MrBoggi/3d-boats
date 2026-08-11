include <hull_stage5_joints.scad>

// Validation selector only. Production export remains disabled until approval.
check_part = "all"; // all, bow, mid, stern

if (check_part == "bow")
    stage5_bow_section();
else if (check_part == "mid")
    stage5_mid_section();
else if (check_part == "stern")
    stage5_stern_section();
else if (check_part == "all")
    union() {
        stage5_bow_section();
        stage5_mid_section();
        stage5_stern_section();
    }
else
    assert(false, str("Unknown Stage 5 validation part: ", check_part));
