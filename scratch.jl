using Pkg
Pkg.activate(".")

using Revise, Cube

# ccall tests
Cube.ccall_simple()
Cube.ccall_array_arg_test()

Cube.run_julia_benchmark()
Cube.run_assembly_benchmark()

Cube.run_assembly()
using Plots
heatmap(a)

using BenchmarkTools
let
    @benchmark Cube.ccall_array_arg_test()
end # let
