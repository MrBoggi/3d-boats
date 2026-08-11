include <config.scad>
use <hull_stage4.scad>
use <bow_bench_stage1.scad>

// Expected result: empty geometry. Any output means a rail enters a pontoon.
intersection() {
    stage4_pontoon_shells();
    union()
        for (side = [-1, 1])
            bow_single_rail_side_part(side);
}
