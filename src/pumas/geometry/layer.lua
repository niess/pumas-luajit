-------------------------------------------------------------------------------
-- Topography layer for a PUMAS Earth geometry
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local error = require('pumas.error')
local topography = require('pumas.geometry.topography')
local metatype = require('pumas.metatype')

local layer = {}


-------------------------------------------------------------------------------
-- The topography layer metatype
-------------------------------------------------------------------------------
local TopographyLayer = {}

function TopographyLayer:__index (k)
    if k == '__metatype' then
        return 'TopographyLayer'
    elseif k == 'data' then
        return self._data
    elseif k == 'medium' then
        return self._medium
    else
        error.raise{['type'] = 'TopographyLayer', bad_member = k}
    end
end

function TopographyLayer.__newindex (_, k)
    if (k == 'data') or (k == 'medium') then
        error.raise{['type'] = 'TopographyLayer', not_mutable = k}
    else
        error.raise{['type'] = 'TopographyLayer', bad_member = k}
    end
end


-------------------------------------------------------------------------------
-- The topography layer constructor
-------------------------------------------------------------------------------
do
    local raise_error = error.ErrorFunction{fname = 'TopographyLayer'}

    local function new (cls, ...)
        local medium, data

        local nargs = select('#', ...)
        if nargs == 1 then
            local args = select(1, ...)
            if metatype(args) == 'table' then
                medium, data = args.medium, args.data
            else
                raise_error{argnum = 1, expected = 'a table',
                    got = metatype.a(args)}
            end
        elseif nargs == 2 then
            medium = select(1, ...)
            data = select(2, ...)
        else
            raise_error{argnum = 'bad', expected = '1 or 2', got = nargs}
        end

        if metatype(medium) ~= 'Medium' then
            local argnum, argname
            if nargs == 1 then
                argname = 'medium'
            else
                argnum = 1
            end

            raise_error{argnum = argnum, argname = argname,
                expected = 'a Medium table', got = metatype.a(medium)}
        end

        do
            local mt = metatype(data)
            if mt == 'table' then
                data = topography.TopographyDataset(data)
            elseif (mt == 'number') or (mt == 'string') then
                data = topography.TopographyData(data)
            elseif (mt ~= 'TopographyData') and (mt ~= 'TopographyDataset') then
                local argnum, argname
                if nargs == 1 then
                    argname = 'data'
                else
                    argnum = 2
                end

                raise_error{argnum = argnum, argname = argname,
                    expected = 'a TopographyData(set) table',
                    got = metatype.a(data)}
            else
                data = data:clone()
            end
        end

        return setmetatable({_medium = medium, _data = data}, cls)
    end

    layer.TopographyLayer = setmetatable(TopographyLayer, {__call = new})
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return layer
