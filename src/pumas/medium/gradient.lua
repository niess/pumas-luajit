-------------------------------------------------------------------------------
-- Uniform medium for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local error = require('pumas.error')
local materials = require('pumas.materials')
local base = require('pumas.medium.base')
local metatype = require('pumas.metatype')

local gradient = {}


-------------------------------------------------------------------------------
-- The gradient medium metatype
-------------------------------------------------------------------------------
local GradientMedium = {}
local strtype = 'GradientMedium'


function GradientMedium:__index (k)
    if k == 'magnet' then
        return self._c.magnet
    else
        return base.BaseMedium.__index(self, k, strtype)
    end
end


function GradientMedium:__newindex (k, v)
    if k == 'magnet' then
        self._c.magnet = v
    else
        base.BaseMedium.__newindex(self, k, v, strtype)
    end
end


-------------------------------------------------------------------------------
-- The gradient medium constructor
-------------------------------------------------------------------------------
do
    local ctype = ffi.typeof('struct pumas_medium_gradient')
    local ctype_ptr = ffi.typeof('struct pumas_medium_gradient *')

    local raise_error = error.ErrorFunction{fname = 'GradientMedium'}

    -- Protected conversion to a number
    local function ptonumber (args, argname)
        local v, ok = args[argname]
        local tp = type(v)
        if tp == 'ctype' then
            ok, v = pcall(ffi.tonumber, v)
        elseif tp == 'number' then
            ok = true
        end

        if ok then
            return v
        else
            raise_error{
                argname = argname, expected = 'a number',
                got = metatype.a(v)}
        end
    end

    local function new (cls, material, args)
        -- Check the number and type of arguments
        if args == nil then
            local nargs = (material ~= nil) and 1 or 0
            raise_error{
                argnum = 'bad', expected = 2, got = nargs}
        end

        if type(args) ~= 'table' then
            raise_error{
                argnum = 2, expected = 'table', got = metatype.a(args)}
        end

        -- Check the named arguments
        local parameters = {'axis', 'lambda', 'rho0', 'type', 'z0'}
        for k, _ in pairs(args) do
            local ok = false
            for _, parameter in ipairs(parameters) do
                if k == parameter then
                    ok = true
                    break
                end
            end
            if not ok then
                raise_error{
                    argname = k, description = 'unknown'}
            end
        end

        -- Parse the gradient type
        local type_
        if args.type then
            if type(args.type) ~= 'string' then
                raise_error{
                    argname = 'type', expected = 'a string',
                    got = metatype.a(args.type)}
            end
            local type_tag = args.type:lower()
            if type_tag == 'linear' then
                type_ = clib.PUMAS_MEDIUM_GRADIENT_LINEAR
            elseif type_tag == 'exponential' then
                type_ = clib.PUMAS_MEDIUM_GRADIENT_EXPONENTIAL
            else
                raise_error{
                    argname = 'type', expected = "'linear' or 'exponential'",
                    got = args.type}
            end
        else
            type_ = clib.PUMAS_MEDIUM_GRADIENT_EXPONENTIAL
        end

        -- Parse the gradient axis
        local axis
        if args.axis == nil then
            axis = 'vertical'
        else
            if type(args.axis) == 'string' then
                axis = args.axis:lower()
                if axis ~= 'vertical' then
                    raise_error{
                        argname = 'axis',
                        description = "bad value '"..args.axis.."'"
                    }
                end
            else
                axis = args.axis
            end
        end

        -- Parse the gradient reference density
        local rho0
        if args.rho0 == nil then
            local m = materials.MATERIALS[material]
            if m then
                rho0 = materials.MATERIALS[material].density
            else
                raise_error{
                    argname = 'rho0', expected = 'a number', got = 'nil'}
            end
        else
            rho0 = ptonumber(args, 'rho0')
        end

        -- Parse the gradient reference altitude
        local z0
        if args.z0 == nil then
            z0 = 0
        else
            z0 = ptonumber(args, 'z0')
        end

        local lambda = ptonumber(args, 'lambda')
        local magnet = args.magnet

        local self = base.BaseMedium.new(ctype, ctype_ptr, material)

        clib.pumas_medium_gradient_initialise(self._c, -1, type_, lambda,
                                               z0, rho0, magnet)
        if axis == 'vertical' then
            self._c.gradient.project =
                clib.pumas_medium_gradient_project_altitude
        else
            self._c.gradient.direction = axis
        end

        return setmetatable(self, cls)
    end

    gradient.GradientMedium = setmetatable(GradientMedium, {__call = new})
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return gradient
