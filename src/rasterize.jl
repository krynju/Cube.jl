function run_julia_rasterize()
    cube = generate_cube_julia()
    output = generate_output_uint32()
    render_rasterize!(output, cube)
end

function render_rasterize!(output::Array{UInt32, 2}, cube::CubeJulia)
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
        vertices[:,i] .= R * cube.vertices[i]
    end

    distance = -100
    half_size = 256

    @inbounds for i = 1:8
        vertices[:,i] = vertices[:,i] .* (distance / vertices[3,i]) .+ half_size
    end

    rasterize!(output, cube, vertices)

    #line drawing
    # @inbounds for c in cube.connections
    #     x1 = vertices[1, c[1]];   y1 = vertices[2, c[1]];
    #     x2 = vertices[1, c[2]];   y2 = vertices[2, c[2]];
    #
    #     dx = x2 - x1
    #     dy = y2 - y1
    #
    #     step = abs(dx) >= abs(dy) ? abs(dx) : abs(dy)
    #
    #     dx = dx / step
    #     dy = dy / step
    #
    #     x = x1; y = y1; i = 1.0
    #
    #     while i <= step
    #         xcord = trunc(Int32, x)
    #         ycord = trunc(Int32, y)
    #         output[xcord, ycord] = 0xFFFFFFFF
    #         x += dx;    y += dy;    i += 1.0
    #     end
    # end
    output
end # function


@inline function rasterize!(output::Array{UInt32, 2}, cube::CubeJulia, vertices::MMatrix{4, 8, Float32})
    colors = SVector{6, UInt32}(0xFFe6194B, 0xFFf58231, 0xFFffe119, 0xFFbfef45, 0xff3cb44b, 0xff42d4f4)

    cube_number = 0

    @inbounds for c in cube.walls
        cube_number = cube_number + 1

        tv11 = vertices[1, c[1]]
        tv21 = vertices[2, c[1]]
        tv12 = vertices[1, c[2]]
        tv22 = vertices[2, c[2]]
        tv13 = vertices[1, c[3]]
        tv23 = vertices[2, c[3]]
        tv14 = vertices[1, c[4]]
        tv24 = vertices[2, c[4]]

        @inbounds for col = 1:size(output)[1]

            @inbounds @simd for row = 1:size(output)[2]
                p1 = convert(Float32, row)
                p2 = convert(Float32, col)

                if(edge_fun(p1, p2, tv11, tv21, tv12, tv22)
                        && edge_fun(p1, p2, tv12, tv22, tv13, tv23)
                        && edge_fun(p1, p2, tv13, tv23, tv14, tv24)
                        && edge_fun(p1, p2, tv14, tv24, tv11, tv21))
                    output[row, col] = colors[cube_number]
                end # if
            end
        end
    end # for

end

function edge_fun(p1::Float32, p2::Float32, u1::Float32, u2::Float32, v1::Float32, v2::Float32)
    return (p1-u1)*(v2-u2)-(p2-u2)*(v1-u1) <= 0
end
