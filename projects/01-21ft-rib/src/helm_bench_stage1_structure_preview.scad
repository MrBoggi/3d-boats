include <config.scad>
include <helm_bench_stage1.scad>

render()
    union() {
        helm_bench_side_frame_part(-1);
        helm_bench_side_frame_part(1);
        helm_bench_cross_braces_part();
        helm_bench_side_rails_part();
    }
