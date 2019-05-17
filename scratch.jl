import Pkg.activate
activate(".")

using Revise, Cube

Cube.prepare_args_assembly_rasterize()
Cube.run_assembly_rasterize()
Cube.run_assembly_rasterize_benchmark()

Cube.run_julia_benchmark()
Cube.run_assembly_benchmark()
Cube.run_julia_rasterize_benchmark()

Cube.run_julia()
Cube.run_assembly()

Cube.run_julia_rasterize()

using Plots
heatmap(Cube.run_julia_rasterize())
heatmap(Cube.run_assembly())

using Colors, ImageView
reinterpret(ARGB32, Cube.run_assembly_rasterize())
