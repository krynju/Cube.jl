using Pkg

Pkg.activate(".")

using Revise, Cube

Cube.simple_ccall()

Cube.run_cube_benchmark_assembly()

using BenchmarkTools
let
    @benchmark Cube.f()
end # let

Cube.run_cube_benchmark_assembly()

Cube.run_cube_benchmark()

using Plots
heatmap(transpose(a))
# Cube.array_arg_test()
