# Medium
_Generic propagation medium for simulations._

## Description

The propagation medium of a simulation is described by a
[TabulatedMaterial](../physics/TabulatedMaterial.md) dressed with two local
properties: its bulk density and / or a local magnetic field. There are
two types of propagation media:
{: .justify}

- a [GradientMedium](GradientMedium.md) whose bulk density varies as a
  unidimensionnal gradient.
- A [UniformMedium](UniformMedium.md) whose bulk density is uniform over the
  whole propagation medium.

The boundaries of a propagation medium are defined by a
[Geometry](../geometry/Geometry) object. In addition there are two special
media instances:
{: .justify}

- the [transparent\_medium](transparent_medium.md) represents the absence of
  proper filling medium in a geometry. Such transparent geometries behave as
  containers for other (daughter) geometries (volumes).
  {: .justify}
- The `nil` medium represents the absence of propagation medium at all. It
  indicates the end of the simulation geometry.


## Examples

```lua
-- Create a rocky uniform propagation medium with default properties
local rock = pumas.UniformMedium('StandardRock')

-- Create an atmosphere like propagation medium with a density gradient
local atmosphere = pumas.GradientMedium('Air', {lambda = -1E+04})
```

## See also

[GradientMedium](GradientMedium.md),
[transparent\_medium](transparent_medium.md),
[UniformMedium](UniformMedium.md).
