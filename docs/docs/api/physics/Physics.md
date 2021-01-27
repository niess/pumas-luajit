# Physics
_A metatype for managing physics tabulations._


<div markdown="1" class="shaded-box fancy">
## Attributes
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The [Physics](Physics.md) constructor has two functional forms as shown in the
synospis below. The first form takes a single path string argument pointing to
pre-computed physics tabulations, e.g. with the [build](build.md) function.  The
second form computes the physics tabulations according to a Material Description
File (MDF) and energy loss tables (*dedx*).
{: .justify }

### Synopsis
```Lua
pumas.Physics(path)

pumas.Physics{dedx, mdf, particle}
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*path*    |`string`| Path to a folder containing pre-computed physics tabulations, e.g. generated with the [build](build.md) function.|
||||
|*dedx*    |`string`| Path to a folder containing energy loss tabulations in the Particle Data Group (PDG) format.|
|*mdf*     |`string`| Path to an XML Material Description File (MDF) describing the target materials, i.e. their atomic composition and physical properties.|
|*particle*|`string`| Name of the transported (projectile) particle. Must be `'muon'` or `'tau'`.|


### Returns

|Type|Description|
|----|-----------|
|`table`| A Lua table of metatype [Physics](Physics.md).|

### See also

[Context](Context.md)
</div>


<div markdown="1" class="shaded-box fancy">
## Physics.dump

### Synopsis
```Lua
Physics:dump(path)
```

## See also
</div>
