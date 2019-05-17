CUBE_HALF_SIDE = 100.0

VERTICES = [
    [-CUBE_HALF_SIDE, CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
    [-CUBE_HALF_SIDE, -CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
    [CUBE_HALF_SIDE, -CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
    [-CUBE_HALF_SIDE, -CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
    [CUBE_HALF_SIDE, -CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
    [CUBE_HALF_SIDE, CUBE_HALF_SIDE, CUBE_HALF_SIDE, 1],
    [-CUBE_HALF_SIDE, CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1],
    [CUBE_HALF_SIDE, CUBE_HALF_SIDE, -CUBE_HALF_SIDE, 1]
]

CONNECTIONS_ASSEMBLY = (
    (0, 3), (0, 5), (0, 6), (1, 3),
    (1, 4), (1, 6), (2, 3), (2, 4),
    (2, 5), (4, 7), (5, 7), (6, 7)
)

WALLS_ASSEMBLY = (
        (2, 4, 7, 5),
        (4, 1, 6, 7),
        (1, 3, 0, 6),
        (3, 2, 5, 0),
        (7, 6, 0, 5),
        (1, 4, 2, 3)
)

CONNECTIONS_JULIA = [[c...] .+ 1 for c in CONNECTIONS_ASSEMBLY]

WALLS_JULIA = [[w...] .+ 1 for w in WALLS_ASSEMBLY]