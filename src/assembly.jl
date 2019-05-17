function run_assembly()
    cube = generate_cube_assembly()
    output = generate_output_uint8()
    ccall_assembly(cube, output)
end

function ccall_assembly(cube::CubeAssembly, output::Array{UInt8, 2})
    ccall((:render, "src/assembly_files/render.lib"), Cvoid, (Ref{CubeAssembly}, Ref{UInt8}), cube, output)
    output
end
