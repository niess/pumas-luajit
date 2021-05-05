-------------------------------------------------------------------------------
-- Coordinates systems for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local frame = require('pumas.coordinates.frame')
local transform = require('pumas.coordinates.transform')
local type_ = require('pumas.coordinates.type')
local metatype = require('pumas.metatype')

local coordinates = {}

coordinates.LocalFrame = frame.LocalFrame
coordinates.UnitaryTransformation = transform.UnitaryTransformation
for k, v in pairs(type_) do
    coordinates[k] = v
end


-- XXX wrap double[3] accessor if possible? E.g. use state.direction.x instead
--     of state.direction[0]


-------------------------------------------------------------------------------
-- Wrap setter for double[3]
-------------------------------------------------------------------------------
function coordinates.set_double3 (self, k, v)
    if metatype(v) == 'Coordinates' then
        self[k] = v:get()
        return true
    else
        local ok, msg = pcall(function () self[k] = v end)
        if ok then
            return true
        else
            return false, msg:match(':%d+: (.+)$')
        end
    end
end


-------------------------------------------------------------------------------
-- Wrap conversion to double[3]
-------------------------------------------------------------------------------
function coordinates.to_double3 (v)
    if metatype(v) == 'Coordinates' then
        return true, v:get()
    else
        local ok, r = pcall(function ()
            return ffi.new('double [3]', v) end)
        if ok then
            return true, r
        else
            return false, r:match(':%d+: (.+)$')
        end
    end
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function coordinates.register_to (t)
    for k, v in pairs(coordinates) do
        if k ~= 'register_to' then
            t[k] = v
        end
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return coordinates
