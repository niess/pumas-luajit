-------------------------------------------------------------------------------
-- Base geometry for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local clib = require('pumas.clib')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local base = {}


-------------------------------------------------------------------------------
-- The base geometry
--
-- Note: this is an incomplete metatype intended to be inherited. It provides
-- common functionalities for geometry types.
-------------------------------------------------------------------------------
base.BaseGeometry = {__index = {}}
base.BaseGeometry.__index.__metatype = 'Geometry'


function base.BaseGeometry:new ()
    local obj = {}
    obj._daughters = {}
    obj._mothers = {}
    obj._valid = true
    return setmetatable(obj, self)
end


function base.BaseGeometry:clone ()
    local mt = {__index = {}}
    mt.new = self.new
    mt.clone = self.clone
    for k, v in pairs(self.__index) do
        mt.__index[k] = v
    end
    return mt
end


local function walk_up (geometry, f)
    for mother, count in pairs(geometry._mothers) do
        if f(mother, count) == true then break end
        walk_up(mother, f)
    end
end


function base.BaseGeometry.__index:_invalidate ()
    walk_up(self, function (g) g._valid = false end)
    self._valid = false
end


do
    local raise_error = error.ErrorFunction{fname = 'insert'}

    function base.BaseGeometry.__index:insert (...)
        local args, index, geometry, arg1 = {...}
        if #args == 0 then
                raise_error{
                    argnum = 'bad',
                    expected = '1 or 2',
                    got = 0
                }
        elseif type(args[1]) == 'number' then
            if #args == 1 then
                raise_error{
                    argnum = 'bad',
                    expected = 2,
                    got = 1
                }
            end
            index, geometry, arg1 = args[1], args[2], 2
        else
            index, geometry, arg1 = 1, args[1], 1
        end

        if geometry.__metatype ~= 'Geometry' then
            raise_error{
                argnum = arg1,
                expected = 'a Geometry table',
                got = metatype.a(geometry)
            }
        end

        -- Invalidate the geometry and its parents
        -- Also check for circular references
        local circular = self == geometry
        if not circular then
            walk_up(self, function (g)
                if g == geometry then
                    circular = true
                    return true
                else
                    g._valid = false
                end
            end)
        end
        if circular then
            raise_error('circular reference')
        end
        self._valid = false

        -- Update references
        local count = geometry._mothers[self] or 0
        geometry._mothers[self] = count + 1

        table.insert(self._daughters, index, geometry)
    end
end


function base.BaseGeometry.__index:remove (index)
    local geometry = table.remove(self._daughters, index)
    if geometry == nil then return end

    -- Update the mother ref
    local count = geometry._mothers[self]
    if count == 1 then
        geometry._mothers[self] = nil
    else
        geometry._mothers[self] = count - 1
    end

    -- Invalidate the geometry and its parents
    walk_up(self, function (g) g._valid = false end)
    self._valid = false

    return geometry
end


local function set_daughters (mother, c_mother)
    for _, daughter in ipairs(mother._daughters) do
        local c_daughter = daughter:_new()
        clib.pumas_geometry_push(c_mother, c_daughter)
        set_daughters(daughter, c_daughter)
    end
end


function base.BaseGeometry.__index:_update (context)
    clib.pumas_geometry_reset(context._c)

    if (clib.pumas_geometry_get(context._c) ~= nil) and self._valid then
        return
    end

    local c = self:_new()
    set_daughters(self, c)
    clib.pumas_geometry_set(context._c, c)
    self._valid = true
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return base
