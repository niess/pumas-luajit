-- Catch segmentation faults
local ffi = require('ffi')

ffi.cdef [[
typedef void (*sighandler_t)(int);
sighandler_t signal(int, sighandler_t);
]]

ffi.C.signal(11, function(signo)
    error('SIGSEGV', 2)
end)


-- Put the JIT loader to the end and add a loader for embedded C packages
package.loaders = (function ()
    local t = package.loaders
    return {
        t[2], t[3], t[4], t[1],
        function(modname)
            return loadcfunction('luaopen_'..modname:gsub('[.]', '_'))
        end
    }
end) ()



-- Set the executable prefix
require('lfs')

local os = require('jit').os
local pathsep = os == 'Windows' and '\\' or '/'

local prefix = (function ()
    local exe = arg[0]

    if exe:match(pathsep) then
        local pwd = lfs.currentdir()
        local pattern = pathsep..'[^'..pathsep..']+$'
        local dirname = exe:gsub(pattern, '')
        if os ~= Windows then  dirname = dirname:gsub(pattern, '') end
        lfs.chdir(dirname)
        local prefix = lfs.currentdir()
        lfs.chdir(pwd)
        return prefix
    else
        return lfs.currentdir()
    end

    return prefix
end) ()

_PREFIX = prefix


-- Use relative search paths for packages
local function Path(...)
    return table.concat({...}, pathsep)
end

package.path = (function ()
    local path
    if os == "Windows" then
        -- XXX is this correct?
        path = Path(prefix, 'lua', '5.1', '')
    else
        path = Path(prefix, 'share', 'lua', '5.1', '')
    end

    local init = Path('?', 'init.lua')
    path = {'?.lua', init, path..'?.lua', path..init}
    return table.concat(path, ';')
end) ()

package.cpath = (function ()
    local cpath, tag
    if os == 'Windows' then
        -- XXX is this correct?
        tag = '?.dll'
        cpath = Path(prefix, 'lua', '5.1', tag)
    else
        tag = '?.so'
        cpath = Path(prefix, 'lib', 'lua', '5.1', tag)
        if os == 'OSX' then
            -- XXX are both .dylib and .so Lua packages supported on OSX?
            tag = '?.dylib;'..tag
            local tmp = Path(prefix, 'lib', 'lua', '5.1', '?.dylib')
            cpath = tmp..';'..cpath
        end
    end

    return table.concat({tag, cpath}, ';')
end) ()


local init = {}


function init.__preload__()
    local i = 1
    while i <= #arg do
        local optstr = arg[i]

        if string.match(optstr, '^[^-]') then break end

        if string.match(optstr, '^[-]L') then
            table.remove(arg, i)
            local optarg
            if optstr == '-L' then
                optarg = table.remove(arg, i)
            else
                optarg = optstr:sub(3)
            end
            if optarg then require(optarg) end
        else
            i = i + 1
        end
    end
end


return init
