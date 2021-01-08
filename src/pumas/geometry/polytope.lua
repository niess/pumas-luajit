-------------------------------------------------------------------------------
-- Convex polytope geometry for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local coordinates = require('pumas.coordinates')
local error = require('pumas.error')
local base = require('pumas.geometry.base')
local medium = require('pumas.medium')
local metatype = require('pumas.metatype')

local polytope = {}


-------------------------------------------------------------------------------
-- The polytope geometry metatype
-------------------------------------------------------------------------------
local PolytopeGeometry = {}

local ctype = ffi.typeof('struct pumas_geometry_polytope')
local ctype_ptr = ffi.typeof('struct pumas_geometry_polytope *')
local pumas_polytope_face_t = ffi.typeof('struct pumas_polytope_face')
local pumas_geometry_ptr = ffi.typeof('struct pumas_geometry *')
local pumas_medium_ptr = ffi.typeof('struct pumas_medium *')


local function new (self)
    return ffi.cast(pumas_geometry_ptr, self._refs[1])
end


local function dot (a, b)
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]
end


local function cross (a, b, c)
    c[0] = a[1] * b[2] - a[2] * b[1]
    c[1] = a[2] * b[0] - a[0] * b[2]
    c[2] = a[0] * b[1] - a[1] * b[0]
end


-- Intersection of 3 planes
-- Ref: https://mathworld.wolfram.com/Plane-PlaneIntersection.html
local function intersect3 (x1, n1, x2, n2, x3, n3, x)
    local det =   n1[0] * n2[1] * n3[2]
                + n2[0] * n3[1] * n1[2]
                + n3[0] * n1[1] * n2[2]
                - n3[0] * n2[1] * n1[2]
                - n1[0] * n3[1] * n2[2]
                - n2[0] * n1[1] * n3[2]
    if math.abs(det) < 1E-13 then return false end

    local x1n1 = dot(x1, n1)
    local x2n2 = dot(x2, n2)
    local x3n3 = dot(x3, n3)
    local n2n3 = ffi.new('double [3]')
    local n3n1 = ffi.new('double [3]')
    local n1n2 = ffi.new('double [3]')
    cross(n2, n3, n2n3)
    cross(n3, n1, n3n1)
    cross(n1, n2, n1n2)

    for k = 0, 2 do
        x[k] = (x1n1 * n2n3[k] + x2n2 * n3n1[k] +
                x3n3 * n1n2[k]) / det
    end

    return true
end


local function convert_polytope (poly, color, all_vertices, all_faces)
    -- Find the vertices
    local vertices = {}
    do
        local vertex = ffi.new('double [3]')
        for i = 0, poly.n_faces - 1 do
            for j = i + 1, poly.n_faces - 1 do
                for k = j + 1, poly.n_faces - 1 do
                    if intersect3(
                        poly.faces[i].origin, poly.faces[i].normal,
                        poly.faces[j].origin, poly.faces[j].normal,
                        poly.faces[k].origin, poly.faces[k].normal,
                        vertex)
                    then
                        local valid = true
                        for l = 0, poly.n_faces - 1 do
                            if (l ~= i) and (l ~= j) and (l ~= k) then
                                local f = poly.faces[l]
                                local d =
                                    f.normal[0] * (vertex[0] - f.origin[0]) +
                                    f.normal[1] * (vertex[1] - f.origin[1]) +
                                    f.normal[2] * (vertex[2] - f.origin[2])
                                if d > 0 then
                                    valid = false
                                    break
                                end
                            end
                        end
                        if valid then
                            local v = ffi.new('double [3]', vertex)
                            table.insert(vertices, {i, j, k, v})
                        end
                    end
                end
            end
        end
    end

    -- Resolve the color
    local wrapped_medium = medium.get(poly.medium)
    local red, green, blue, alpha = color(wrapped_medium)

    -- Map the faces
    local index0 = #all_vertices
    for i = 0, poly.n_faces - 1 do
        local index, n_vertices = {}, 0
        for _, vertex in ipairs(vertices) do
            if (i == vertex[1]) or (i == vertex[2]) or (i == vertex[3]) then
                table.insert(index, {0, vertex[4]})
                n_vertices = n_vertices + 1
            end
        end

        if n_vertices >= 3 then
            local c = ffi.new('double [3]')
            for _, vertex in ipairs(index) do
                for k = 0, 2 do
                    c[k] = c[k] + vertex[2][k]
                end
            end
            for k = 0, 2 do
                c[k] = c[k] / #index
            end

            local ux = ffi.new('double [3]')
            local norm = 0
            for k = 0, 2 do
                ux[k] = index[1][2][k] - c[k]
                norm = norm + ux[k]^2
            end
            norm = 1 / math.sqrt(norm)
            for k = 0, 2 do
                ux[k] = ux[k] * norm
            end

            local uy = ffi.new('double [3]')
            cross(poly.faces[i].normal, ux, uy)

            for _, vertex in ipairs(index) do
                local r = ffi.new('double [3]')
                for k = 0, 2 do
                    r[k] = vertex[2][k] - c[k]
                end
                local x = dot(r, ux)
                local y = dot(r, uy)

                vertex[1] = math.atan2(y, x)
            end

            table.sort(index, function (a, b)
                return a[1] < b[1]
            end)

            local nx = tonumber(poly.faces[i].normal[0])
            local ny = tonumber(poly.faces[i].normal[1])
            local nz = tonumber(poly.faces[i].normal[2])
            for j, vertex in ipairs(index) do
                local r = vertex[2]
                table.insert(all_vertices, {tonumber(r[0]), tonumber(r[1]),
                    tonumber(r[2]), nx, ny, nz, red, green, blue, alpha})
                index[j] = index0 + j - 1
            end
            index0 = index0 + #index

            for j = 1, #index - 2 do
                table.insert(all_faces,
                    {index[1], index[j + 1], index[j + 2]})
            end
        end
    end

    -- Convert daughter volumes
    local daughter = poly.base.daughters
    while daughter ~= nil do
        local p = ffi.cast('struct pumas_geometry_polytope *', daughter)
        convert_polytope(p, color, all_vertices, all_faces)
        daughter = daughter.next
    end
end


local ply_initialised = false

local function export_ply (self, path, color)
    local vertices, faces = {}, {}
    convert_polytope(self._refs[1], color, vertices, faces)

    if not ply_initialised then
        ffi.cdef([[
        struct ply_vertex {
            float x;
            float y;
            float z;
            float nx;
            float ny;
            float nz;
            unsigned char red;
            unsigned char green;
            unsigned char blue;
            unsigned char alpha;
        };
        ]])
    end

    local header = string.format([[
ply
format binary_little_endian 1.0
comment PUMAS geometry
element vertex %d
property float x
property float y
property float z
property float nx
property float ny
property float nz
property uchar red
property uchar green
property uchar blue
property uchar alpha
element face %d
property list uchar int vertex_indices
end_header
]], #vertices, #faces)

    local file = io.open(path, 'w')
    file:write(header)
    local v = ffi.new('struct ply_vertex[1]')
    for _, vertex in ipairs(vertices) do
        v[0] = vertex
        ffi.C.fwrite(v, ffi.sizeof('struct ply_vertex'), 1, file)
    end
    local size = ffi.new('unsigned char [1]')
    for _, face in ipairs(faces) do
        size[0] = #face
        ffi.C.fwrite(size, ffi.sizeof(size), 1, file)
        local index = ffi.new('int [?]', #face, face)
        ffi.C.fwrite(index, ffi.sizeof('int'), #face, file)
    end
end


local export
do
    local raise_error = error.ErrorFunction{fname = 'export'}

    function export (self, path, options)
        if type(path) ~= 'string' then
            raise_error{
                argnum = 2,
                expected = 'a string',
                got = metatype.a(path)
            }
        end

        options = options or {}
        local color_type, color = type(options.color)
        if color_type == 'function' then
            color = options.color
        elseif color_type == 'table' then
            local red = options.color.red or options.color[1] or 0
            local green = options.color.green or options.color[2] or 0
            local blue = options.color.blue or options.color[3] or 0
            local alpha = options.color.alpha or options.color[4] or 255

            color = function (medium_)
                local m_r, m_g, m_b, m_a = unpack(options.color[medium_])
                if m_r or m_b or m_g or m_a then
                    m_r = m_r or 0
                    m_g = m_g or 0
                    m_b = m_b or 0
                    m_a = m_a or 255
                    return m_r, m_g, m_b, m_a
                else
                    return red, green, blue, alpha
                end
            end
        elseif color_type == 'nil' then
            color = function ()
                return 255, 255, 255, 255
            end
        else
            raise_error{
                argname = 'color',
                expected = 'a table or function',
                got = metatype.a(options.color)
            }
        end

        local extension = path:match('^.+(%..+)$')
        local lext = extension:lower()
        if lext == '.ply' then
            export_ply(self, path, color)
        else
            raise_error{
                argnum = 2,
                description = 'unknown format '..extension
            }
        end
    end
end


function PolytopeGeometry.__index (_, k)
    if k == '_new' then
        return new
    elseif k == 'export' then
        return export
    elseif (k == 'insert') or (k == 'remove') then
        return
    else
        return base.BaseGeometry.__index[k]
    end
end


local function get_tag(depth, index)
    local tag = '#'..depth
    if index > 0 then tag = tag..'.'..index end
    return tag
end


-------------------------------------------------------------------------------
-- The polytope geometry constructor
-------------------------------------------------------------------------------
local point, vector

local function build_polytopes (args, frame, refs, depth, index)
    local medium_, data, daughters = args[1], args[2], args[3]

    if (medium_ ~= nil) and (medium_.__metatype ~= 'Medium') then
        error.raise{
            fname = 'Polytope '..get_tag(depth, index),
            argnum = 1,
            expected = 'a Medium table',
            got = metatype.a(medium),
            depth = depth + 2
        }
    end

    if type(data) ~= 'table' then
        error.raise{
            fname = 'Polytope '..get_tag(depth, index),
            argnum = 2,
            expected = 'a table',
            got = metatype.a(data),
            depth = depth + 2
        }
    end

    local n_faces = math.floor(#data / 6)
    if #data ~= 6 * n_faces then
        error.raise{
            fname = 'Polytope '..get_tag(depth, index),
            argnum = 2,
            expected = 'n x 6 values',
            got = #data,
            depth = depth + 2
        }
    end

    if (daughters ~= nil) and (type(daughters) ~= 'table') then
        error.raise{
            fname = 'Polytope '..get_tag(depth, index),
            argnum = 3,
            expected = 'nil or a table',
            got = metatype.a(daughters),
            depth = depth + 2
        }
    end

    local size = ffi.sizeof(ctype) +
                 n_faces * ffi.sizeof(pumas_polytope_face_t)
    local mother = ffi.cast(ctype_ptr, ffi.C.calloc(1, size))
    ffi.gc(mother, ffi.C.free)
    table.insert(refs, mother)

    mother.base.get = ffi.C.pumas_geometry_polytope_get
    if medium_ ~= nil then
        mother.medium = ffi.cast(pumas_medium_ptr, medium_._c)
        refs[medium_._c] = true
    end
    mother.n_faces = n_faces

    for i = 0, n_faces - 1 do
        mother.faces[i].origin[0] = data[6 * i + 1]
        mother.faces[i].origin[1] = data[6 * i + 2]
        mother.faces[i].origin[2] = data[6 * i + 3]
        mother.faces[i].normal[0] = data[6 * i + 4]
        mother.faces[i].normal[1] = data[6 * i + 5]
        mother.faces[i].normal[2] = data[6 * i + 6]

        if frame ~= nil then
            local origin = mother.faces[i].origin
            point:set(origin)
            point.frame = frame
            point:transform(nil)
            origin[0] = point.x
            origin[1] = point.y
            origin[2] = point.z

            local normal = mother.faces[i].normal
            vector:set(normal)
            vector.frame = frame
            vector:transform(nil)
            normal[0] = vector.x
            normal[1] = vector.y
            normal[2] = vector.z
        end
    end

    mother = ffi.cast(pumas_geometry_ptr, mother)

    if daughters ~= nil then
        local last_daughter
        for i, daughter_args in ipairs(daughters) do
            local daughter = build_polytopes(daughter_args, frame, refs,
                                             depth + 1, i)
            if i == 1 then
                mother.daughters = daughter
            else
                last_daughter.next = daughter
            end
            daughter.mother = mother
            last_daughter = daughter
        end
    end

    return mother
end


local function load_ply (_)
    error.raise{
        fname = 'PolytopeGeometry.load',
        description = 'PLY format not implemented'
    }
end


function polytope.PolytopeGeometry (args, frame)
    local self = base.BaseGeometry:new()
    self._refs = {}

    if frame ~= nil then
        point = coordinates.CartesianPoint()
        vector = coordinates.CartesianVector()
    end

    if type(args) == 'string' then
        args = load_ply(args)
    end

    build_polytopes(args, frame, self._refs, 1, 0)

    if frame ~= nil then
        point = nil
        vector = nil
    end

    return setmetatable(self, PolytopeGeometry)
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return polytope
