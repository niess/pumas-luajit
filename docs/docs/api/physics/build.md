# Build
_Build physics tabulations for a set of materials and composites._

The [build](build.md) function allows to pre-compute (tabulate) the
[physics](../Physics.md) for a given projectile and a set of target materials.
The resulting tabulations are stored on disk.  They are used by
[Physics](Physics.md) instances for simulating the physics of the transport.
{: .justify}

This function takes a single table argument as detailed in the synopsis below.
One must provide a table of materials to tabulate. Other keyword arguments are
optionnal. The materials table can contain [Material](Material.md) instances
indexed by name or directly name `string`s refering to existing entries in the
[materials](../data/materials.md) table (see the [examples](#examples) below).
{: .justify}

## Synopsis
``` lua
pumas.build{
    materials=, (compile)=, (composites)=, (energies)=, (particle)=, (path)=}
```

## Arguments

|Name|Type|Description|
|----|----|-----------|
|*materials*   |`table`  | The table can contain [Material](Material.md) instances indexed by name or directly name `string`s refering to existing entries in the [materials](../data/materials.md) table (see the [examples](#examples) below).|
||||
|(*compile*)   |`boolean`| Compile the tabulations to a ready to use binary format. Default: `True`.|
|(*composites*)|`table`  | Mapping with keys naming composite materials and values providing their composition. Default: `nil`.|
|(*energies*)  |`table`  | List of kinetic energy values to tabulate. Default: see below.|
|(*particle*)  |`string` | Name of the transported (projectile) particle. Must be `'muon'` or `'tau'`. Default: `'muon'`.|
|(*path*)      |`table`  | Path under which to store the tabulations. Default: `'.'`.|

If kinetic *energies* values are not specified a log like default sampling is
used. For muons the exact same sampling than in the Particle Data Group
([PDG](https://pdg.lbl.gov/2020/AtomicNuclearProperties/index.html)) energy loss
files is used. For taus a logarithmic sampling is used ranging from 100 GeV to
10<sup>12</sup> GeV with 20 points per decade.
{: .justify}

## Returns

`nil`

## Examples

``` lua
-- Create a water material for illustrative purpose. Note that the latter
-- is readily available from pumas.materials.
local water = pumas.Material{density = 1E+03, formula = 'H2O'}

pumas.build{
    -- Table of base materials mixing both allowed syntax.
    materials = {'Air', 'StandardRock', Water = water},

    -- Composite (mixtures) of base materials with their mass fractions.
    composites = {
        WetRock = {StandardRock = 0.7, Water = 0.3}
    },

    -- Path where to store the tabulations.
    path = 'share/materials/examples'
}
```

## See also

[CompositeMaterials](CompositeMaterials.md),
[Element](Element.md),
[Material](Material.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).
