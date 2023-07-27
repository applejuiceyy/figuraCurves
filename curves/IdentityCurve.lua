
local class         = require("curves/class")
local deriveMatrix  = require("curves/deriveMatrix")


local IdentityCurve = class("IdentityCurve")

function IdentityCurve:init(matrix, p1, p2, p3, p4, control)
    self.matrix = matrix

    self.p1 = p1
    self.p2 = p2
    self.p3 = p3
    self.p4 = p4

    self.control = control or function(t) return vec(t * t * t, t * t, t, 1) end
end

function IdentityCurve:compute(t)
    return (self.control(t) * self.matrix)
end

function IdentityCurve:get(t)
    local computed = self:compute(t)
    return computed.x * self.p1 + computed.y * self.p2 + computed.z * self.p3 + computed.w * self.p4
end

function IdentityCurve:derive()
    return IdentityCurve:new(
        deriveMatrix(self.matrix),
        self.p1,
        self.p2,
        self.p3,
        self.p4
    )
end

function IdentityCurve:canDerive()
    return true
end

function IdentityCurve:getCurrentCurve(_)
    return self
end


--[[
local curve = IdentityCurve:new(
    Curves.LINEAR,
    vec(0, 0, 0),
    vec(10, 0, 0),
    vec(0, 10, 0),
    vec(10, 0, 0)
)
local speed = curve:derive()
local acceleration = speed:derive()
local jerk = acceleration:derive()

function events.tick()
    curve.p1.x = math.cos(world.getTime() / 10) * 100

    for i = 0, 30 do
        local spot = curve:get(i / 30)
        particles:newParticle("dust 1 1 1 1", spot)
        local spoint = speed:get(i / 30)
        local apoint = acceleration:get(i / 30)
        local jpoint = jerk:get(i / 30)

        for x = 0, 10 do
            particles:newParticle("dust 0 1 0 0.4", spoint / 100 * x + spot)
            particles:newParticle("dust 1 0 0 0.4", apoint / 1000 * x + spot)
            particles:newParticle("dust 0 0 1 0.4", jpoint / 1000 * x + spot)
        end
    end

    particles:newParticle("dust 1 0 1 3", curve.p1)
    particles:newParticle("dust 1 0 1 3", curve.p2)
    particles:newParticle("dust 1 0 1 3", curve.p3)
    particles:newParticle("dust 1 0 1 3", curve.p4)

    for i = 0, 100 do
        local v = vec(i / 10, 0, 0)
        local p = curve:compute(i / 100) * 10
        particles:newParticle("dust 0 1 0 0.4", p._x_ + v):velocity()
        particles:newParticle("dust 1 0 0 0.4", p._y_ + v):velocity()
        particles:newParticle("dust 0 0 1 0.4", p._z_ + v):velocity()
        particles:newParticle("dust 1 1 0 0.4", p._w_ + v):velocity()
        particles:newParticle("dust 0.5 0.5 0.5 0.4", v)
        particles:newParticle("dust 0.5 0.5 0.5 0.4", v + vec(0, 10, 0))
    end
end]]

return IdentityCurve