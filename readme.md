# Curves in figura
who doesn't like a bezier curve or a hermit curve every now and then
```lua
local IdentityCurve  = require("curves/IdentityCurve")
local Curves         = require("curves/Curves")

local curve = IdentityCurve:new(
    Curves.BEZIER_CURVE,
    -- supports any value
    -- as long as it can be multiplied by a number and added together
    vec( 0,  0, 0),
    vec( 0, 10, 0),
    vec(10,  0, 0),
    vec(10, 10, 0)
)

local speed = curve:derive()
local acceleration = speed:derive()
local jolt = acceleration:derive()

print("pos at 0.5 is", curve:get(0.5))
print("speed at 0.5 is", speed:get(0.5))
print("acceleration at 0.5 is", acceleration:get(0.5))
print("jolt at 0.5 is", jolt:get(0.5))
```