using Pkg
Pkg.activate(".")
Pkg.instantiate()
using Revise, Cube


Cube.run_julia_rasterize()
Cube.run_assembly_rasterize_avx()
Cube.run_assembly_rasterize_avx2()

Cube.benchmark_julia_rasterize()
Cube.benchmark_assembly_rasterize_avx()
Cube.benchmark_assembly_rasterize_avx2()

using Colors, ImageView
reinterpret(ARGB32, Cube.run_julia_rasterize())
reinterpret(ARGB32, Cube.run_assembly_rasterize_avx())
reinterpret(ARGB32, Cube.run_assembly_rasterize_avx2())


Cube.run_julia()
Cube.run_assembly()

Cube.benchmark_julia()
Cube.benchmark_assembly()

using Plots
heatmap(Cube.run_assembly())
heatmap(Cube.run_julia())
