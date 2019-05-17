function prepare_args_assembly()
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

    v = ([Point_assembly((vertice...,)) for vertice in vertices]...,)
    p_v = ([rand()*10.0, rand()*10.0, -200.0]...,)
    r_v = ([rand()*pi*1.0, rand()*pi*1.0, rand()*pi*1.0]...,)
    c = ([Connection_assembly(x[1], x[2]) for x in connections]...,)

    cube = Cube_assembly(v, p_v, r_v, c)
    output = zeros(UInt8, 512*3, 512)

    return (cube, output)
end

function run_assembly()
    cube, output = prepare_args_assembly()
    ccall_assembly(cube, output)
end

function run_assembly_benchmark()
    @benchmark ccall_assembly($(prepare_args_assembly()[1]), $(prepare_args_assembly()[2]))

end

function ccall_assembly(cube::Cube_assembly, output::Array{UInt8, 2})
    ccall((:render, "src/assembly_files/render.lib"), Cvoid, (Ref{Cube_assembly}, Ref{UInt8}), cube, output)
    output
end

function ccall_simple()
    ccall((:simple_fun, "src/assembly_files/simple.lib"), Int32, (Int32,), 10)

    val = 10
    val_ref = Ref{Int32}(val)
    ccall((:simple_fun_pointer, "src/assembly_files/simple.lib"), Cvoid, (Ref{Int32},), val_ref)
    val_ref[]

    cube, output = prepare_args_assembly()
    output2 = Array{UInt8,1}(undef, 786486)

    ccall((:simple_fun_args, "src/assembly_files/simple.lib"), Float32,(Ref{Cube_assembly}, Ref{UInt8}), cube, output2)

    input = Array{Int32,1}([3, 5, 88])
    ccall((:array_arg, "src/assembly_files/simple.lib"), Int32, (Ref{Int32},), input)
end
