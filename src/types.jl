struct CubeAssembly
    vertices::NTuple{8, NTuple{4, Float32}}
    position_vector::NTuple{3, Float32}
    rotation_vector::NTuple{3, Float32}
    connections::NTuple{12, NTuple{2, Int32}}
    walls::NTuple{6, NTuple{4, Int32}}

end

struct CubeJulia
    vertices::SVector{8, SVector{4, Float32}}
    position_vector::SVector{3, Float32}
    rotation_vector::SVector{3, Float32}
    connections::SVector{12, SVector{2, Int32}}
    walls::SVector{6, SVector{4, Int32}}
end
