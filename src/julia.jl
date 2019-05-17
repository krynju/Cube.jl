function run_julia()
    cube = generate_cube_julia()
    output = generate_output_uint8()
    render!(output, cube)
end

function render!(output::Array{UInt8, 2}, cube::CubeJulia)
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
        vertices[:,i] .= vertices[:,i] .* (distance / vertices[3,i]) .+ half_size
    end

    #line drawing
    @inbounds for c in cube.connections
        x1 = vertices[1, c[1]];   y1 = vertices[2, c[1]];
        x2 = vertices[1, c[2]];   y2 = vertices[2, c[2]];

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
