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

struct Point_julia_rasterize
    position_vector::SVector{4, Float32}
end


struct Connection_julia_rasterize
    from::Int32
    to::Int32
end


struct Cube_julia_rasterize
    vertices::SVector{8, Point_julia_rasterize}
    position_vector::SVector{3, Float32}
    rotation_vector::SVector{3, Float32}
    connections::SVector{12, Connection_julia_rasterize}
    walls::SVector{6, SVector{4, Int32}}
end
