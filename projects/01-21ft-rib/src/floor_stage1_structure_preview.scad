include <config.scad>
include <floor_stage1.scad>

check_part = "assembly"; // assembly, fixed, bow, mid, stern, battery_lid, aft_lid

if (check_part == "assembly") {
    render() cockpit_floor_fixed();
    render() floor_battery_lid();
    render() floor_aft_lid();
} else if (check_part == "fixed")
    render() cockpit_floor_fixed();
else if (check_part == "bow")
    render() floor_bow_section();
else if (check_part == "mid")
    render() floor_mid_section();
else if (check_part == "stern")
    render() floor_stern_section();
else if (check_part == "battery_lid")
    render() floor_battery_lid();
else if (check_part == "aft_lid")
    render() floor_aft_lid();
else
    assert(false, str("Unknown floor check_part: ", check_part));
