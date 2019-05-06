module Cube

using LinearAlgebra
using BenchmarkTools
using StaticArrays

struct Point
    position_vector::Vector{Float64}
end

struct Connection
    from::Int64
    to::Int64
end

struct DrawnObject
    vertices::Vector{Point}
    position_vector::Vector{Float64}
    rotation_vector::Vector{Float64}
    connections::Vector{Connection}
end

struct Point_C
    position_vector::NTuple{4, Float32}
end

struct Connection_C
    from::Int32
    to::Int32
end

struct DrawnObject_C
    vertices::NTuple{8, Point_C}
    position_vector::NTuple{3, Float32}
    rotation_vector::NTuple{3, Float32}
    connections::NTuple{12, Connection_C}
end


struct Point_optimised
    position_vector::SVector{4, Float32}
end

struct Connection_optimised
    from::Int32
    to::Int32
end

struct DrawnObject_optimised
    vertices::SVector{8, Point_optimised}
    position_vector::SVector{3, Float32}
    rotation_vector::SVector{3, Float32}
    connections::SVector{12, Connection_optimised}
end

function prepare_args()
    CUBE_HALF_SIDE = 100.0

    vertices = [[-CUBE_HALF_SIDE, CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
            [-CUBE_HALF_SIDE, -CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
            [CUBE_HALF_SIDE, -CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
            [-CUBE_HALF_SIDE, -CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
            [CUBE_HALF_SIDE, -CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
            [CUBE_HALF_SIDE, CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
            [-CUBE_HALF_SIDE, CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
            [CUBE_HALF_SIDE, CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1]]

    connections = [(0, 3), (0, 5), (0, 6), (1, 3), (1, 4), (1, 6), (2, 3), (2, 4), (2, 5), (4, 7), (5, 7), (6, 7)]

    v = [Point(vertice) for vertice in vertices]
    p_v = [0.0, 0.0, -200.0]
    r_v = [0.0, 0.0, 30.0]
    c = [Connection(x[1], x[2]) for x in connections]

    cube = DrawnObject(v, p_v, r_v, c)
    output = zeros(UInt8, 512*3, 512)

    return (cube, output)
end

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

    v = ([Point_C((vertice...,)) for vertice in vertices]...,)
    p_v = ([rand()*10.0, rand()*10.0, -200.0]...,)
    r_v = ([rand()*pi*1.0, rand()*pi*1.0, rand()*pi*1.0]...,)
    c = ([Connection_C(x[1], x[2]) for x in connections]...,)

    cube = DrawnObject_C(v, p_v, r_v, c)
    output = zeros(UInt8, 512*3, 512)

    return (cube, output)
end

function prepare_args_julia_optimised()
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

    v = [Point_optimised(vertice) for vertice in vertices]
    p_v = [rand()*10.0, rand()*10.0, -200.0]
    r_v = [rand()*pi*1.0, rand()*pi*1.0, rand()*pi*1.0]
    c = [Connection_optimised(x[1], x[2]) for x in connections]

    cube = DrawnObject_optimised(v, p_v, r_v, c)
    output = zeros(UInt8, 512*3, 512)

    return (cube, output)
end

function run_julia_benchmark()
    cube, output = prepare_args()
    @benchmark render!($output, $cube)
end

function run_julia_optimised_benchmark()
    cube, output = prepare_args_julia_optimised()
    @benchmark render_optimised!($output, $cube)
end

function run_julia()
    cube, output = prepare_args()
    render!(output, cube)
end

function run_julia_optimised()
    cube, output = prepare_args_julia_optimised()
    render_optimised!(output, cube)
end


function render!(output::Array{UInt8, 2}, cube::DrawnObject)
    # construct rotation matrix

    Rz = Matrix{Float64}(I, 4, 4)
    Rz[1, 1] = cos(cube.rotation_vector[3])
    Rz[1, 2] = sin(cube.rotation_vector[3])
    Rz[2, 1] = -sin(cube.rotation_vector[3])
    Rz[2, 2] = cos(cube.rotation_vector[3])

    Ry = Matrix{Float64}(I, 4, 4)
    Ry[1, 1] = cos(cube.rotation_vector[2])
    Ry[3, 1] = sin(cube.rotation_vector[2])
    Ry[1, 3] = -sin(cube.rotation_vector[2])
    Ry[3, 3] = cos(cube.rotation_vector[2])

    Rx = Matrix{Float64}(I, 4, 4)
    Rx[2, 2] = cos(cube.rotation_vector[1])
    Rx[2, 3] = sin(cube.rotation_vector[1])
    Rx[3, 2] = -sin(cube.rotation_vector[1])
    Rx[3, 3] = cos(cube.rotation_vector[1])

    R = Rz * Ry * Rx

    @inbounds R[1:3,4] = cube.position_vector

    # vertices = [Vector{Float64}(undef, 4) for _ in 1:8]
    #
    # for i = 1:8
    #     vertices[i] = R * cube.vertices[i].position_vector
    # end

    @inbounds vertices = map(cube.vertices) do x
        R * x.position_vector
    end

    distance = -100
    half_size = 256

    @inbounds cords = map(vertices) do x
        (x .* (distance / x[3]) .+ half_size )
    end

    # line drawing

    for c in cube.connections
        from = cords[c.from + 1]
        to = cords[c.to + 1]

        x1 = from[1]
        y1 = from[2]

        x2 = to[1]
        y2 = to[2]

        dx = x2 - x1
        dy = y2 - y1

        step = abs(dx) >= abs(dy) ? abs(dx) : abs(dy)

        dx = dx / step
        dy = dy / step

        x = x1
        y = y1
        i = 1.0

        while i <= step
            xcord = trunc(Int32, x) * 3
            ycord = trunc(Int32, y)

            output[xcord:xcord+2, ycord] .= 0xFF

            x += dx
            y += dy
            i += 1.0
        end
    end
    output
end

function render_optimised!(output::Array{UInt8, 2}, cube::DrawnObject_optimised)
    # construct rotation matrix

    Rz = Matrix{Float32}(I, 4, 4)
    Rz[1, 1] = cos(cube.rotation_vector[3])
    Rz[1, 2] = sin(cube.rotation_vector[3])
    Rz[2, 1] = -sin(cube.rotation_vector[3])
    Rz[2, 2] = cos(cube.rotation_vector[3])

    Ry = Matrix{Float32}(I, 4, 4)
    Ry[1, 1] = cos(cube.rotation_vector[2])
    Ry[3, 1] = sin(cube.rotation_vector[2])
    Ry[1, 3] = -sin(cube.rotation_vector[2])
    Ry[3, 3] = cos(cube.rotation_vector[2])

    Rx = Matrix{Float32}(I, 4, 4)
    Rx[2, 2] = cos(cube.rotation_vector[1])
    Rx[2, 3] = sin(cube.rotation_vector[1])
    Rx[3, 2] = -sin(cube.rotation_vector[1])
    Rx[3, 3] = cos(cube.rotation_vector[1])

    R = Rz * Ry * Rx

    R[1,4] = cube.position_vector[1]
    R[2,4] = cube.position_vector[2]
    R[3,4] = cube.position_vector[3]

    vertices = @MMatrix zeros(Float32, 4, 8)

    @inbounds for i = 1:8
        vertices[:,i] .= R * cube.vertices[i].position_vector
    end

    distance = -100
    half_size = 256

    cords = @MMatrix zeros(Float32, 2, 8)

    @inbounds for i = 1:8
        x = vertices[:,i]
        cords[:,i] .= (x[1:2] .* (distance / x[3]) .+ half_size )
    end



    # line drawing

    @inbounds for c in cube.connections
        from = cords[:, c.from + 1]
        to = cords[:, c.to + 1]

        x1 = from[1];   y1 = from[2];
        x2 = to[1];     y2 = to[2]

        dx = x2 - x1
        dy = y2 - y1

        step = abs(dx) >= abs(dy) ? abs(dx) : abs(dy)

        dx = dx / step
        dy = dy / step

        x = x1; y = y1; i = 1.0

        while i <= step
            xcord = trunc(Int32, x) * 3
            ycord = trunc(Int32, y)

            output[xcord:xcord+2, ycord] .= 0xFF

            x += dx;    y += dy;    i += 1.0
        end
    end
    output
end # function

function ccall_simple()
    ccall((:simple_fun, "src/simple.lib"), Int32, (Int32,), 10)

    val = 10
    val_ref = Ref{Int32}(val)
    ccall((:simple_fun_pointer, "src/simple.lib"), Cvoid, (Ref{Int32},), val_ref)
    val_ref[]

    cube, output = prepare_args_assembly()
    output2 = Array{UInt8,1}(undef, 786486)

    ccall((:simple_fun_args, "src/simple.lib"), Float32,(Ref{DrawnObject_C}, Ref{UInt8}), cube, output2)
end

function ccall_array_arg_test()
    input = Array{Int32,1}([3, 5, 88])
    ccall((:array_arg, "src/simple.lib"), Int32, (Ref{Int32},), input)
end

function run_assembly()
    cube, output = prepare_args_assembly()
    ccall_assembly_render(cube, output)
    output
end

function run_assembly_benchmark()
    # cube, output = prepare_args_assembly()
    b = @benchmarkable ccall_assembly_render($(prepare_args_assembly()[1]), $(prepare_args_assembly()[2]))
    run(b)
end

function ccall_assembly_render(cube::DrawnObject_C, output::Array{UInt8, 2})
    ccall((:render, "src/render.lib"), Cvoid, (Ref{DrawnObject_C}, Ref{UInt8}), cube, output)
    output
end

end # module
