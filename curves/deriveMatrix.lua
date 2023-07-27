return function (matrix)
    return matrices.mat4(
        vec(0, 0, 0, 0),
        matrix:getColumn(1) * 3,
        matrix:getColumn(2) * 2,
        matrix:getColumn(3) * 1
    )
end