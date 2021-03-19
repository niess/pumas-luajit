-------------------------------------------------------------------------------
-- Utilities for testing the spec
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local assert = require('luassert')
local lfs = require('lfs')
local pumas = require('pumas')
local readonly = require('pumas.readonly')

local util = {}


-------------------------------------------------------------------------------
-- A dummy transformation
-------------------------------------------------------------------------------
util.DummyTransformation = setmetatable(
    {check = function (t)
        assert.is.equal(t.translation[0], 1)
        assert.is.equal(t.translation[1], 2)
        assert.is.equal(t.translation[2], 3)
        local n = 4
        for i = 0, 2 do
            for j = 0, 2 do
                assert.is.equal(t.matrix[i][j], n)
                n = n + 1
            end
        end
    end}, {

    __call = function ()
        return pumas.UnitaryTransformation({1, 2, 3},
            {{4, 5, 6}, {7, 8, 9}, {10, 11, 12}})
    end})


-------------------------------------------------------------------------------
-- An Euler rotation matrix (extrinsic: Z, Y, X)
-- Ref: https://en.wikipedia.org/wiki/Euler_angles
-------------------------------------------------------------------------------
util.EulerMatrix = setmetatable(
    {__index = {check = function (self, t, precision)
        precision = precision or 7

        for i, vi in ipairs(self) do
            for j, vij in ipairs(vi) do
                assert.is.equal(util.round(vij, precision),
                    util.round(t.matrix[i - 1][j - 1], precision))
            end
        end
    end}},

    {__call = function (cls, ...)
        local a1 = select(1, ...) or 0
        local a2 = select(2, ...) or 0
        local a3 = select(3, ...) or 0

        local c1, s1 = math.cos(a1), math.sin(a1)
        local c2, s2 = math.cos(a2), math.sin(a2)
        local c3, s3 = math.cos(a3), math.sin(a3)

        local self = {
            {c1 * c2, c1 * s2 * s3 - c3 * s1, s1 * s3 + c1 * c3 * s2},
            {c2 * s1, c1 * c3 + s1 * s2 * s3, c3 * s1 * s2 - c1 * s3},
            {-s2, c2 * s3, c2 * c3}
        }

        return setmetatable(self, cls)
    end})


-------------------------------------------------------------------------------
-- Identity transformation
-------------------------------------------------------------------------------
util.IdentityTransformation = setmetatable(
    {check = function (t)
        for i = 0, 2 do
            assert.is.equal(t.translation[i], 0)
            for j = 0, 2 do
                local v = (i == j) and 1 or 0
                assert.is.equal(t.matrix[i][j], v)
            end
        end
    end},

    {__call = function ()
        return pumas.UnitaryTransformation()
    end})


-------------------------------------------------------------------------------
-- A central symmetry transformation
-------------------------------------------------------------------------------
function util.Reflection ()
    return pumas.UnitaryTransformation{
        matrix = {{-1, 0, 0}, {0, -1, 0}, {0, 0, -1}}}
end


-------------------------------------------------------------------------------
-- Round floats to a given numeric precision
-------------------------------------------------------------------------------
function util.round (v, precision)
    precision = precision or 7
    return math.floor(v * 10^precision + 0.5) * 10^(-precision)
end


-------------------------------------------------------------------------------
-- Dot product of C arrays
-------------------------------------------------------------------------------
function util.dot (a, b, precision)
    local d = a[0] * b[0] + a[1] * b[1] + a[2] * b[2]
    if precision then
        d = util.round(d, precision)
    end
    return d
end


-------------------------------------------------------------------------------
-- Assert that a transform is unitary
-------------------------------------------------------------------------------
function util.assert_unitary (t)
    assert.is.equal(0, util.dot(t.matrix[0], t.matrix[1], 7))
    assert.is.equal(0, util.dot(t.matrix[0], t.matrix[2], 7))
    assert.is.equal(0, util.dot(t.matrix[1], t.matrix[2], 7))
    assert.is.equal(1, util.dot(t.matrix[0], t.matrix[0], 7))
    assert.is.equal(1, util.dot(t.matrix[1], t.matrix[1], 7))
    assert.is.equal(1, util.dot(t.matrix[2], t.matrix[2], 7))
end


-------------------------------------------------------------------------------
-- A dummy muon flux spectrum
-------------------------------------------------------------------------------
function util.dummy_spectrum () return 1 end


-------------------------------------------------------------------------------
-- Locate the flux tabulation data
-------------------------------------------------------------------------------
function util.muon_flux_data ()
    for _, path in ipairs{'build-release', 'build-debug'} do
        if lfs.attributes(path, 'mode') == 'directory' then
            return path..'/src/atmospheric-muon-flux/data/simulated'
        end
    end
end


-------------------------------------------------------------------------------
-- Count the number of elements in a table
-------------------------------------------------------------------------------
function util.getn (t)
    if getmetatable(t) == 'Readonly' then
        t = readonly.rawget(t)
    end

    local n = 0
    for _, _ in pairs(t) do n = n + 1 end
    return n
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return util
