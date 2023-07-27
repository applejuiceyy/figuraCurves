--testing purposes, feel free to exclude

local SHOW_PARTICLE = false
local SHOW_GRAPH = false

if SHOW_PARTICLE or SHOW_GRAPH then
    local IdentityCurve  = require("curves/IdentityCurve")
    local WeightedSpline = require("curves/WeightedSpline")
    local Curves         = require("curves/Curves")


    local curve = WeightedSpline:new(
        {
            weight = 2,
            curve = IdentityCurve:new(
                Curves.BEZIER_CURVE,
                vec(0, 0, 0),
                vec(0, 5, 0),
                vec(0, 10, 0),
                vec(10, 0, 0)
            )
        },

        {
            weight = 1,
            curve = IdentityCurve:new(
                Curves.LINEAR,
                vec(10, 0, 0),
                vec(0, 0, 0),
                vec(0, 0, 0),
                vec(0, 0, 0)
            )
        }
    )



    local speed = curve:derive()
    local acceleration = speed:derive()
    local jerk = acceleration:derive()

    function events.render(t)
        local i = world.getTime(t) % 50

        if SHOW_PARTICLE then
            local spot = curve:get(i / 50)
            particles:newParticle("dust 1 1 1 1", spot)
            local spoint = speed:get(i / 50)
            local apoint = acceleration:get(i / 50)
            local jpoint = jerk:get(i / 50)

            for x = 0, 10 do
                particles:newParticle("dust 0 1 0 0.4", spoint / 100 * x + spot)
                particles:newParticle("dust 1 0 0 0.4", apoint / 1000 * x + spot)
                particles:newParticle("dust 0 0 1 0.4", jpoint / 1000 * x + spot)
            end

            particles:newParticle("dust 1 0 1 1", curve:getCurrentCurve(i / 50).p1):lifetime(10)
            particles:newParticle("dust 1 0 1 1", curve:getCurrentCurve(i / 50).p2):lifetime(10)
            particles:newParticle("dust 1 0 1 1", curve:getCurrentCurve(i / 50).p3):lifetime(10)
            particles:newParticle("dust 1 0 1 1", curve:getCurrentCurve(i / 50).p4):lifetime(10)
        end

        if SHOW_GRAPH then
            local curves = {curve, speed, acceleration, jerk}
            local index = math.floor(world.getTime() / 100) % #curves + 1
            local current = curves[index]
            local separation = 100 * math.pow(2, index)

            for pos = 0, separation do
                local v = vec(pos * (1 / separation) * 10, 0, 0)
                local p = current:getCurrentCurve(i / 50):compute(pos / separation) * 10
                particles:newParticle("dust 0 1 0 0.4", p._x_ + v):velocity()
                particles:newParticle("dust 1 0 0 0.4", p._y_ + v):velocity()
                particles:newParticle("dust 0 0 1 0.4", p._z_ + v):velocity()
                particles:newParticle("dust 1 1 0 0.4", p._w_ + v):velocity()
                particles:newParticle("dust 0.5 0.5 0.5 0.4", v)
                particles:newParticle("dust 0.5 0.5 0.5 0.4", v + vec(0, 10, 0))
            end
        end
    end
end