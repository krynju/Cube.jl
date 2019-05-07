module Cube

using LinearAlgebra
using BenchmarkTools
using StaticArrays

export run_julia, run_julia_benchmark, run_assembly, run_assembly_benchmark

struct Point_assembly
    position_vector::NTuple{4, Float32}
end

struct Connection_assembly
    from::Int32
    to::Int32
end

struct Cube_assembly
    vertices::NTuple{8, Point_assembly}
    position_vector::NTuple{3, Float32}
    rotation_vector::NTuple{3, Float32}
    connections::NTuple{12, Connection_assembly}
end

struct Point_julia
    position_vector::SVector{4, Float32}
end

struct Connection_julia
    from::Int32
    to::Int32
end

struct Cube_julia
    vertices::SVector{8, Point_julia}
    position_vector::SVector{3, Float32}
    rotation_vector::SVector{3, Float32}
    connections::SVector{12, Connection_julia}
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

    v = ([Point_assembly((vertice...,)) for vertice in vertices]...,)
    p_v = ([rand()*10.0, rand()*10.0, -200.0]...,)
    r_v = ([rand()*pi*1.0, rand()*pi*1.0, rand()*pi*1.0]...,)
    c = ([Connection_assembly(x[1], x[2]) for x in connections]...,)

    cube = Cube_assembly(v, p_v, r_v, c)
    output = zeros(UInt8, 512*3, 512)

    return (cube, output)
end

function prepare_args_julia()
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

    v = [Point_julia(vertice) for vertice in vertices]
    p_v = [rand()*10.0, rand()*10.0, -200.0]
    r_v = [rand()*pi*1.0, rand()*pi*1.0, rand()*pi*1.0]
    c = [Connection_julia(x[1], x[2]) for x in connections]

    cube = Cube_julia(v, p_v, r_v, c)
    output = zeros(UInt8, 512*3, 512)

    return (cube, output)
end

function run_julia_benchmark()
    # cube, output = prepare_args_julia()
    @benchmark render!($(prepare_args_julia()[2]), $(prepare_args_julia()[1]))
end


function run_julia()
    cube, output = prepare_args_julia()
    render!(output, cube)
end

function render!(output::Array{UInt8, 2}, cube::Cube_julia)
    # construct rotation matrix

    Rz = @MMatrix zeros(Float32, 4, 4)
    Rz[1, 1] = cos(cube.rotation_vector[3])
    Rz[1, 2] = sin(cube.rotation_vector[3])
    Rz[2, 1] = -sin(cube.rotation_vector[3])
    Rz[2, 2] = cos(cube.rotation_vector[3])
    Rz[3, 3] = 1.0
    Rz[4, 4] = 1.0

    Ry = @MMatrix zeros(Float32, 4, 4)
    Ry[1, 1] = cos(cube.rotation_vector[2])
    Ry[3, 1] = sin(cube.rotation_vector[2])
    Ry[1, 3] = -sin(cube.rotation_vector[2])
    Ry[3, 3] = cos(cube.rotation_vector[2])
    Ry[2, 2] = 1.0
    Ry[4, 4] = 1.0

    Rx = @MMatrix zeros(Float32, 4, 4)
    Rx[2, 2] = cos(cube.rotation_vector[1])
    Rx[2, 3] = sin(cube.rotation_vector[1])
    Rx[3, 2] = -sin(cube.rotation_vector[1])
    Rx[3, 3] = cos(cube.rotation_vector[1])
    Rx[1, 1] = 1.0
    Rx[4, 4] = 1.0

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

    @inbounds for i = 1:8
        vertices[:,i] .= vertices[:,i] .* (distance / vertices[3,i]) .+ half_size
    end

    #line drawing
    @inbounds for c in cube.connections
        from = vertices[:, c.from + 1]
        to = vertices[:, c.to + 1]

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

    ccall((:simple_fun_args, "src/simple.lib"), Float32,(Ref{Cube_assembly}, Ref{UInt8}), cube, output2)

    input = Array{Int32,1}([3, 5, 88])
    ccall((:array_arg, "src/simple.lib"), Int32, (Ref{Int32},), input)
end

function run_assembly()
    cube, output = prepare_args_assembly()
    ccall_assembly(cube, output)
end

function run_assembly_benchmark()
    @benchmark ccall_assembly($(prepare_args_assembly()[1]), $(prepare_args_assembly()[2]))

end

function ccall_assembly(cube::Cube_assembly, output::Array{UInt8, 2})
    ccall((:render, "src/render.lib"), Cvoid, (Ref{Cube_assembly}, Ref{UInt8}), cube, output)
    output
end

end # module
