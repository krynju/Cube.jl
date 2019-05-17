function benchmark_assembly()
    @benchmark ccall_assembly($(generate_cube_assembly()), $(generate_output_uint8()))
end

function benchmark_julia()
    @benchmark render!($(generate_output_uint8()), $(generate_cube_julia()))
end

function benchmark_julia_rasterize()
    @benchmark render_rasterize!($(generate_output_uint32()), $(generate_cube_julia()))
end

function benchmark_assembly_rasterize_avx()
    @benchmark ccall_assembly_rasterize_avx($(generate_cube_assembly()), $(generate_output_uint32()))
end

function benchmark_assembly_rasterize_avx2()
    @benchmark ccall_assembly_rasterize_avx2($(generate_cube_assembly()), $(generate_output_uint32()))
end
