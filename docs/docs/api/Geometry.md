# Geometry
_Generic geometry for simulations._

## Description

The geometry of a simulation is specified using volumes filled with
[media](medium/Medium.md). A [Geometry](Geometry.md) metatype is specialised
in representing volumes with a specific shape or a familly of shapes. For
example:
{: .justify}

- the [EarthGeometry](geometry/EarthGeometry.md) can represent an Earth
  topography using data from one or more Digital Elevation Models (DEMs).
- The [InfiniteGeometry](geometry/InfiniteGeometry.md) represents a volume of
  infinite extension filled with a single medium.
- The [PolyhedronGeometry](geometry/PolyhedronGeometry.md) allows to represent a
  collection of imbricated convex polyhedrons.

Geometries can be nested using the `Geometry.insert` method following the same
semantic than the `table.insert` function. A nested (daughter) geometry has
precedence over its mother on the sub-space delimited by its volume. An
arbitrary number of daughters can be nested but they must not overlap with each
other nor out of the mother volume. The `Geometry.remove` method allows to
withdraw a daughter geometry.
{: .justify}


## Examples

```lua
-- Initialise the world geometry as an infinite volume filled with air
local world = pumas.InfiniteGeometry('Air')

-- Insert an Earth filled with water into the world geometry
world:insert(pumas.EarthGeometry{medium = 'Water', data = 0})
```

## See also

[EarthGeometry](geometry/EarthGeometry.md),
[InfiniteGeometry](geometry/InfiniteGeometry.md),
[PolyhedronGeometry](geometry/PolyhedronGeometry.md).
