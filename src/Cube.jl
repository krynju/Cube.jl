module Cube

using LinearAlgebra
using BenchmarkTools
using StaticArrays

include("types.jl")
include("assembly.jl")
include("julia.jl")
include("rasterize.jl")
include("assembly_rasterize.jl")

export run_julia, run_julia_benchmark, run_assembly, run_assembly_benchmark

end # module Cube
