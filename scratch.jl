import Pkg.activate
activate(".")

using Revise, Cube

Cube.run_julia_benchmark()
Cube.run_assembly_benchmark()

Cube.run_assembly()
Cube.run_julia()

using Plots
heatmap(Cube.run_julia())
heatmap(Cube.run_assembly())
