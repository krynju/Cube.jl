function benchmark_assembly()
    @benchmark ccall_assembly(cube, output) setup=(cube = generate_cube_assembly(); output = generate_output_uint8())
end

function benchmark_julia()
    @benchmark render!(output, cube) setup=(cube = generate_cube_julia(); output = generate_output_uint8())
end

function benchmark_julia_rasterize()
    @benchmark render_rasterize!(output, cube) setup=(cube = generate_cube_julia(); output = generate_output_uint32())
end

function benchmark_assembly_rasterize_avx()
    @benchmark ccall_assembly_rasterize_avx(cube, output) setup=(cube = generate_cube_assembly(); output = generate_output_uint32())
end

function benchmark_assembly_rasterize_avx2()
    @benchmark ccall_assembly_rasterize_avx2(cube, output) setup=(cube = generate_cube_assembly(); output = generate_output_uint32())
end
