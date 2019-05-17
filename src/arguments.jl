function generate_cube_julia()
    p = [rand() * 10.0, rand() * 10.0, -200.0]
    r = [rand() * pi * 1.0, rand() * pi * 1.0, rand() * pi * 1.0]
    return CubeJulia(VERTICES, p, r, CONNECTIONS_JULIA , WALLS_JULIA)
end

function generate_cube_assembly()
    v = ([(vertice...,) for vertice in VERTICES]...,)
    p = ( rand() * 10.0, rand() * 10.0, -200.0 )
    r = ( rand() * pi * 1.0, rand() * pi * 1.0, rand() * pi * 1.0)
    return CubeAssembly(v, p, r, CONNECTIONS_ASSEMBLY, WALLS_ASSEMBLY)
end

function generate_output_uint8()
    return zeros(UInt8, 512 * 3, 512)
end

function generate_output_uint32()
    return zeros(UInt32, 512, 512)
end
