local deriveMatrix = require("curves/deriveMatrix")

local Curves = {}

Curves.BEZIER_CURVE = matrices.mat4(
    vec(-1, 3,-3, 1),
    vec( 3,-6, 3, 0),
    vec(-3, 3, 0, 0),
    vec( 1, 0, 0, 0)
)

Curves.DERIVED_BEZIER_CURVE = deriveMatrix(Curves.BEZIER_CURVE)

Curves.HERMIT_CURVE = matrices.mat4(
    vec( 2, 1,-2, 1),
    vec(-3,-2, 3,-1),
    vec( 0, 1, 0, 0),
    vec( 1, 0, 0, 0)
)
Curves.DERIVED_HERMIT_CURVE = deriveMatrix(Curves.HERMIT_CURVE)

Curves.CARDINAL_SPLINE = function(s)
    return matrices.mat4(
        vec(  -s, 2-s,   s-2,  s),
        vec( 2*s, s-3, 3-2*s, -s),
        vec(  -s,   0,     s,  0),
        vec(   0,   1,     0,  0)
    )
end
Curves.DERIVED_CARDINAL_SPLINE = function(s) deriveMatrix(Curves.CARDINAL_SPLINE(s)) end


Curves.SCALED_CARDINAL_SPLINE = Curves.CARDINAL_SPLINE(1)
Curves.DERIVED_SCALED_CARDINAL_SPLINE = Curves.DERIVED_CARDINAL_SPLINE(1)
Curves.CATMULLROM_SPLINE = Curves.CARDINAL_SPLINE(0.5)
Curves.DERIVED_CATMULLROM_SPLINE = Curves.DERIVED_CARDINAL_SPLINE(0.5)

Curves.LINEAR = matrices.mat4(
    vec( 0, 0, 0, 0),
    vec( 0, 0, 0, 0),
    vec( -1, 1, 0, 0),
    vec( 1, 0, 0, 0)
)

return Curves