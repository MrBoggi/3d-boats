include <config.scad>
include <bow_bench_stage1.scad>

check_part = "base";

if (check_part == "base")
    render() bow_bench_locker_base_part();
else if (check_part == "cushion")
    render() bow_bench_cushion_part();
else if (check_part == "rail_port")
    render() bow_single_rail_side_part(-1);
else if (check_part == "rail_starboard")
    render() bow_single_rail_side_part(1);
else if (check_part == "anchor_roller")
    render() bow_anchor_roller_part();
else
    assert(false, str("Unknown bow check part: ", check_part));
