function run_assembly_rasterize_avx()
    cube = generate_cube_assembly()
    output = generate_output_uint32()
    ccall_assembly_rasterize_avx(cube, output)
end

function run_assembly_rasterize_avx2()
    cube = generate_cube_assembly()
    output = generate_output_uint32()
    ccall_assembly_rasterize_avx2(cube, output)
end

function ccall_assembly_rasterize_avx(cube::CubeAssembly, output::Array{UInt32, 2})
    ccall((:render, "src/assembly_rasterize_files/render_avx.lib"), Cvoid, (Ref{CubeAssembly}, Ref{UInt32}), cube, output)
    output
end

function ccall_assembly_rasterize_avx2(cube::CubeAssembly, output::Array{UInt32, 2})
    ccall((:render, "src/assembly_rasterize_files/render_avx2.lib"), Cvoid, (Ref{CubeAssembly}, Ref{UInt32}), cube, output)
    output
end
