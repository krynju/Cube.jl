import Pkg.activate
activate(".")

using Revise, Cube


Cube.run_julia_rasterize()
Cube.run_assembly_rasterize()

Cube.run_julia_rasterize_benchmark()
Cube.run_assembly_rasterize_benchmark()

using Colors, ImageView
reinterpret(ARGB32, Cube.run_assembly_rasterize())
reinterpret(ARGB32, Cube.run_julia_rasterize())


Cube.run_julia()
Cube.run_assembly()

Cube.run_julia_benchmark()
Cube.run_assembly_benchmark()

using Plots
heatmap(Cube.run_assembly())
heatmap(Cube.run_julia())
