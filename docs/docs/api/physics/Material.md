# pumas.Material
_A metatype for defining material properties._


<div markdown="1" class="shaded-box fancy">
## Attributes
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

### Synopsis
```Lua
function pumas.Material {}
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|**path**    |`string`| Path to a folder containing pre-computed physics tabulations, e.g. generated with [pumas.build](#pumasbuild).|
||||
|**dedx**    |`string`| Path to a folder containing energy loss tabulations in the Particle Data Group (PDG) format.|
|**mdf**     |`string`| Path to an XML Material Description File (MDF) describing the target materials, i.e. their atomic composition and physical properties.|
|**particle**|`string`| Name of the transported (projectile) particle. Must be `'muon'` or `'tau'`.|


### Returns

|Type|Description|
|----|-----------|
|`table`| A Lua table of metatype [pumas.Material](Material.md).|

### See also

[pumas.build](build.md), [pumas.Element](Element.md),
[pumas.MATERIALS](MATERIALS.md)
</div>
