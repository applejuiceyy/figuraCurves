
local class   = require("curves/class")


local Spline = class("Spline")


function Spline:init(...)
    self.curves = {...}
end

function Spline:get(t)
    local normal = t * #self.curves
    local v = self.curves[1 + math.floor(normal)]
    return v:get(normal - math.floor(normal))
end

function Spline:derive()
    local calculated = {}
    for _, curve in ipairs(self.curves) do
        if not curve:canDerive() then
            return nil
        end
        table.insert(calculated, curve:derive())
    end
    return Spline:new(table.unpack(calculated))
end

function Spline:canDerive()
    for _, curve in ipairs(self.curves) do
        if not curve:canDerive() then
            return false
        end
    end
    return true
end

function Spline:getCurrentCurve(t)
    local normal = t * #self.curves
    return self.curves[1 + math.floor(normal)]:getCurrentCurve(normal - math.floor(normal))
end

return Spline