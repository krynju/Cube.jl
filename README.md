# Cube.jl

Julia version of cube_renderer -> https://github.com/krynju/cube_renderer

Contains a nice, allocation-free function with exactly the same functionality as the original.

# ccall examples 

This project also contains some examples of Julia's ccall function usage with the ccall calling the assembly function being the most interesting one. 

Warning: Included binaries and assembly files are compatibile with win64 ABI.

Instructions used to build from the sources included are contained in comments on top of the files. TODO: makefile

# Benchmarks

Assembly call from Julia was implemented for the sole reason of benchmarking it. 

Here are some results:

```
julia> Cube.run_julia_benchmark()
BenchmarkTools.Trial:
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     2.200 μs (0.00% GC)
  median time:      2.256 μs (0.00% GC)
  mean time:        2.437 μs (0.00% GC)
  maximum time:     20.311 μs (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     9
```

```
julia> Cube.run_assembly_benchmark()
BenchmarkTools.Trial:
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     2.022 μs (0.00% GC)
  median time:      2.056 μs (0.00% GC)
  mean time:        2.250 μs (0.00% GC)
  maximum time:     14.655 μs (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     9
```
