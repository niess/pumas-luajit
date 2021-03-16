-------------------------------------------------------------------------------
-- Uniform medium for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local error = require('pumas.error')
local material_ = require('pumas.material')
local base = require('pumas.medium.base')
local metatype = require('pumas.metatype')

local gradient = {}


-------------------------------------------------------------------------------
-- The gradient medium metatype
-------------------------------------------------------------------------------
local GradientMedium = {}
local strtype = 'GradientMedium'


local gradient_density
do
    local state = ffi.new('struct pumas_state_extended')

    function gradient_density (self, arg)
        if metatype(self) ~= 'Medium' then
            error.raise{fname = 'density', argnum = 1,
                expected = 'a GradientMedium table', got = metatype.a(self)}
        end

        local mt, s = metatype(arg)
        if mt == 'State' then
            s = ffi.cast('struct pumas_state_extended *', arg._c)
        elseif mt == 'Coordinates' then
            state.base.position = arg:get()
            s = state
        else
            local ok, msg = pcall(function ()
                state.base.position = arg
            end)
            if ok then
                s = state
            else
                error.raise{fname = density, argnum = 2, description = msg}
            end
        end

        return tonumber(clib.pumas_medium_gradient_density(self._c, s))
    end

    error.register('GradientMedium.__index.density', gradient_density)
end


function GradientMedium:__index (k)
    if k == 'density' then
        return gradient_density
    elseif k == 'axis' then
        if self._c.gradient.project == nil then
            return self._c.gradient.axis
        else
            return 'vertical'
        end
    elseif k == 'lambda' then
        return tonumber(self._c.gradient.lambda)
    elseif k == 'rho0' then
        return tonumber(self._c.gradient.rho0)
    elseif k == 'type' then
        if self._c.gradient.type == clib.PUMAS_MEDIUM_GRADIENT_LINEAR then
            return 'linear'
        else
            return 'exponential'
        end
    elseif k == 'z0' then
        return tonumber(self._c.gradient.z0)
    elseif k == 'magnet' then
        return self._c.magnet
    else
        return base.BaseMedium.__index(self, k, strtype)
    end
end


function GradientMedium:__newindex (k, v)
    if k == 'axis' then
        if v == 'vertical' then
            self._c.gradient.project =
                clib.pumas_medium_gradient_project_altitude
        else
            self._c.gradient.project = nil
            self._c.gradient.axis = v
        end
    elseif k == 'lambda' then
        self._c.gradient.lambda = v
    elseif k == 'rho0' then
        self._c.gradient.rho0 = v
    elseif k == 'type' then
        if type(v) == 'string' then
            v = v:lower()
        else
            return error.raise{fname = 'GradientMedium', argname = 'type',
                expected = 'a string', got = metatype.a(v)}
        end

        if v == 'linear' then
            self._c.gradient.type = clib.PUMAS_MEDIUM_GRADIENT_LINEAR
        elseif v == 'exponential' then
            self._c.gradient.type = clib.PUMAS_MEDIUM_GRADIENT_EXPONENTIAL
        else
            return error.raise{fname = 'GradientMedium', argname = 'type',
                description = "unknown type '"..v.."'"}
        end
    elseif k == 'z0' then
        self._c.gradient.z0 = v
    elseif k == 'magnet' then
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
        local parameters = {'axis', 'lambda', 'rho0', 'type', 'z0', 'magnet'}
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
            local m = material_.materials[material]
            if m then
                rho0 = m.density
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

        if magnet then
            local ok = pcall(function ()
                magnet = ffi.new('double [3]', magnet)
            end)
            if not ok then
                raise_error{
                    argname = 'magnet',
                    expected = 'a size 3 table or array of numbers',
                    got = 'something else'}
            end
        end

        local self = base.BaseMedium.new(ctype, ctype_ptr, material)

        clib.pumas_medium_gradient_initialise(self._c, -1, type_, lambda,
                                               z0, rho0, magnet)
        if axis == 'vertical' then
            self._c.gradient.project =
                clib.pumas_medium_gradient_project_altitude
        else
            self._c.gradient.axis = axis
        end

        return setmetatable(self, cls)
    end

    gradient.GradientMedium = setmetatable(GradientMedium, {__call = new})
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return gradient
