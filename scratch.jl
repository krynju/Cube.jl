using Pkg
Pkg.activate(".")

using Revise, Cube

# ccall tests
Cube.ccall_simple()
Cube.ccall_array_arg_test()


Cube.run_julia_benchmark()

Cube.run_julia_optimised_benchmark()

Cube.run_assembly_benchmark()





Cube.run_assembly()
Cube.run_julia_optimised()
Cube.run_julia()


using Plots
heatmap(Cube.run_julia())
heatmap(Cube.run_assembly())
heatmap(Cube.run_julia_optimised())
