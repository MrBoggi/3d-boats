include <config.scad>
include <hull_stage4.scad>

check_part = "all"; // all, bow, mid or stern

if (check_part == "all")
    stage4_complete_structure();
else if (check_part == "bow")
    stage4_bow_section();
else if (check_part == "mid")
    stage4_mid_section();
else if (check_part == "stern")
    stage4_stern_section();
else
    assert(false, str("Unknown Stage 4 check_part: ", check_part));
