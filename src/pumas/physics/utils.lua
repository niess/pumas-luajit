-------------------------------------------------------------------------------
-- Utilities for PUMAS Physics
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local lfs = require('lfs')
local clib = require('pumas.clib')
local os = require('pumas.os')

local utils = {}


-------------------------------------------------------------------------------
-- Conversion between particles C type and strings
-------------------------------------------------------------------------------
function utils.particle_ctype (name, raise_error)
    if name == nil then
        return clib.PUMAS_PARTICLE_MUON
    else
        if type(name) ~= 'string' then
            raise_error{
                argname = 'particle',
                expected = 'a string',
                got = 'a '..type(name)
            }
        end

        local tmp = name:lower()
        if tmp == 'muon' then
            return clib.PUMAS_PARTICLE_MUON
        elseif tmp == "tau" then
            return clib.PUMAS_PARTICLE_TAU
        else
            raise_error{
                argname = 'particle',
                expected = "'muon' or 'tau'",
                got = "'"..name.."'"
            }
        end
    end
end


function utils.particle_string (ctype)
    if ctype == clib.PUMAS_PARTICLE_MUON then
        return 'muon'
    elseif ctype == clib.PUMAS_PARTICLE_TAU then
        return 'tau'
    end
end


-------------------------------------------------------------------------------
-- Convert a Camel like name to a snaky one
-------------------------------------------------------------------------------
do
    local function f (w) return '_'..w:lower() end

    function utils.snakify (camel)
        camel = camel:sub(1,1):lower()..camel:sub(2)
        return camel:gsub('%u', f)
                    :gsub('%d+', f)
    end
end


-------------------------------------------------------------------------------
-- Text buffer used for building up multi-lines text contents
-------------------------------------------------------------------------------
do
    local Text = {__index={}}

    -- Add a line of text
    function Text.__index:push (s,...)
        table.insert(self, string.format(s,...))
        return self
    end

    -- Pop the full text with OS specific line seps
    function Text.__index:pop ()
        return table.concat(self, os.LINESEP)
    end

    function utils.Text () return setmetatable({}, Text) end
end


-------------------------------------------------------------------------------
-- Recursively create a new directory if it does not already exist
-------------------------------------------------------------------------------
function utils.makedirs (path)
    local dir = ''
    for s in path:gmatch(os.PATHSEP..'?[^'..os.PATHSEP..']+') do
        dir = dir..s
        if lfs.attributes(dir, 'mode') == nil then
            local ok, err = lfs.mkdir(dir)
            if not ok then return nil, err end
        end
    end
    return true
end


-------------------------------------------------------------------------------
-- Return the sub-package
-------------------------------------------------------------------------------
return utils
