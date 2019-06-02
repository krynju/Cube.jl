using Pkg
Pkg.add("JLD2")
Pkg.activate(".")
Pkg.instantiate()


using Cube, JLD2, Dates, InteractiveUtils


Cube.run_julia_rasterize()
Cube.run_assembly_rasterize_avx()
Cube.run_assembly_rasterize_avx2()
Cube.run_julia()
Cube.run_assembly()

b_julia = Cube.benchmark_julia()
b_assembly = Cube.benchmark_assembly()

b_julia_rasterize = Cube.benchmark_julia_rasterize()
b_avx_rasterize = Cube.benchmark_assembly_rasterize_avx()
b_avx2_rasterize = Cube.benchmark_assembly_rasterize_avx2()

filename = "benchmark_results" * Dates.format(Dates.now(), "yymmddHHMMSS") * ".jld2"
io = IOBuffer()
versioninfo(io; verbose=true)
ver = String(take!(io))

@save filename ver b_julia b_assembly b_julia_rasterize b_avx_rasterize b_avx2_rasterize
