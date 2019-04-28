module Cube

using LinearAlgebra
using BenchmarkTools

export run_cube, render!

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
    output = zeros(UInt8, 512, 512*3)

    return (cube, output)
end

function run_cube_benchmark()
    cube, output = prepare_args()
    @benchmark render!($output, $cube)
end

function run_cube()
    cube, output = prepare_args()
    render!(output, cube)
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

    vertices = map(cube.vertices) do x
        R * x.position_vector
    end

    distance = -100
    half_size = 256

    cords = map(vertices) do x
        (x .* (distance / x[3]) .+ half_size )
    end

    # line drawing

    @inbounds for c in cube.connections
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

            output[ycord, xcord] = 0xFF
            output[ycord, xcord + 1] = 0xFF
            output[ycord, xcord + 2] = 0xFF

            x += dx
            y += dy
            i += 1.0
        end
    end
    output

end

greet() = print("Hello World!")


end # module
