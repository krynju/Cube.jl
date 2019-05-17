function prepare_args_assembly_rasterize()
    CUBE_HALF_SIDE =75.0

    vertices = [[-CUBE_HALF_SIDE, CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
            [-CUBE_HALF_SIDE, -CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
            [CUBE_HALF_SIDE, -CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
            [-CUBE_HALF_SIDE, -CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
            [CUBE_HALF_SIDE, -CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
            [CUBE_HALF_SIDE, CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
            [-CUBE_HALF_SIDE, CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
            [CUBE_HALF_SIDE, CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1]]

    connections = [(0, 3), (0, 5), (0, 6), (1, 3), (1, 4), (1, 6), (2, 3), (2, 4), (2, 5), (4, 7), (5, 7), (6, 7)]

    v = ([(vertice...,) for vertice in vertices]...,)
    p_v = ([rand()*10.0, rand()*10.0, -200.0]...,)
    r_v = ([rand()*pi*1.0, rand()*pi*1.0, rand()*pi*1.0]...,)
    c = ([(x[1], x[2]) for x in connections]...,)
    walls = (
    (2, 4, 7, 5),
    (4, 1, 6, 7),
    (1, 3, 0, 6),
    (3, 2, 5, 0),
    (7, 6, 0, 5),
    (1, 4, 2, 3)

        )
    cube = CubeAssembly(v, p_v, r_v, c,walls)
    output = zeros(UInt32, 512, 512)

    return (cube, output)
end

function run_assembly_rasterize()
    cube, output = prepare_args_assembly_rasterize()
    ccall_assembly_rasterize_avx(cube, output)
end

function run_assembly_rasterize_benchmark()
    @benchmark ccall_assembly_rasterize_avx($(prepare_args_assembly_rasterize()[1]), $(prepare_args_assembly_rasterize()[2]))

end

function ccall_assembly_rasterize_avx(cube::CubeAssembly, output::Array{UInt32, 2})
    ccall((:render, "src/assembly_rasterize_files/render_avx.lib"), Cvoid, (Ref{CubeAssembly}, Ref{UInt32}), cube, output)
    output
end

function ccall_assembly_rasterize_avx2(cube::CubeAssembly, output::Array{UInt32, 2})
    ccall((:render, "src/assembly_rasterize_files/render_avx2.lib"), Cvoid, (Ref{CubeAssembly}, Ref{UInt32}), cube, output)
    output
end
