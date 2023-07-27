
local class   = require("curves/class")


local WeightedSpline = class("WeightedSpline")


function WeightedSpline:init(...)
    self.curves = {...}
    self.total = 0
    for _, v in ipairs(self.curves) do
        self.total = self.total + v.weight
    end
end

function WeightedSpline:get(t)
    local curve, time = self:_getCurrent(t)
    return curve:get(time)
end

function WeightedSpline:derive()
    local calculated = {}
    for _, curve in ipairs(self.curves) do
        if not curve.curve:canDerive() then
            return nil
        end
        table.insert(calculated, {weight=curve.weight, curve=curve.curve:derive()})
    end
    return WeightedSpline:new(table.unpack(calculated))
end

function WeightedSpline:canDerive()
    for _, curve in ipairs(self.curves) do
        if not curve.curve:canDerive() then
            return false
        end
    end
    return true
end

function WeightedSpline:getCurrentCurve(t)
    local curve, time = self:_getCurrent(t)
    return curve:getCurrentCurve(time)
end

function WeightedSpline:_getCurrent(t)
    local current = 0
    t = t * self.total
    for i, v in ipairs(self.curves) do
        local next = current + v.weight

        if t >= current and t <= next or i == #self.curves then
            local l = t - current
            return v.curve, l / v.weight
        end
        current = next
    end
end

return WeightedSpline