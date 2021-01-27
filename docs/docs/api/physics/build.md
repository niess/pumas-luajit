# Build
_Build physics tabulations for a set of materials and composites._

The [build](build.md) function allows to pre-compute tabulations for a given
projectile and a set of target materials. These tabulations are stored on disk.
They are used by [Physics](Physics.md) instances for simulating the physics of
the transport.
{: .justify}

This function takes a single table argument as detailed in the synopsis below.
One must provide a list of materials to tabulate. Other keys are optional.
{: .justify}

## Synopsis
``` lua
pumas.build{materials[, compile, composites, energies, particle, path]}
```

## Arguments

|Name|Type|Description|
|----|----|-----------|
|*materials* |`table` | List of [Material](Material.md) or name `string` refering to existing entries in the [MATERIALS](MATERIALS.md) table.|
||||
|*compile*   |`boolean`| Compile the tabulations to a ready to use binary format. Default: `True`.|
|*composites*|`table`  | Mapping with keys naming composite materials and values providing their composition. Default: `nil`.|
|*energies*  |`table`  | List of kinetic energy values to tabulate. Default: see below.|
|*particle*  |`string` | Name of the transported (projectile) particle. Must be `'muon'` or `'tau'`. Default: `'muon'`.|
|*path*      |`table`  | Path under which to store the tabulations. Default: `'.'`.|


## Returns

`nil`

## Examples

``` lua
pumas.build{
    -- List of base materials.
    materials = {'StandardRock', 'WaterLiquid', 'AirDry1Atm'},

    -- Composite (mixtures) of base materials with their mass fractions.
    composites = {
        WetRock = {StandardRock = 0.7, WaterLiquid = 0.3}
    },

    -- Path to store the tabulations.
    path = 'share/materials/standard'
}
```

## See also

[Physics](Physics.md)
