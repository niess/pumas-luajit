# Element
_A metatype for defining atomic elements properties._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*Z*|`number`| Atomic charge number. |
|*A*|`number`| Atomic mass number, in g/mol. |
|*I*|`number`| Mean Excitation Energy (MEE), in GeV. |
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The [Element](Element.md) metatype is a simple container for atomic elements
properties. Its constructor takes three mandatory arguments as detailled in the
synopsis below: the atomic charge number, *Z*, the atomic mass, *A* and the
Mean Excitation Energy, *I* of its electronic structure.
{: .justify}

### Synopsis
```Lua
pumas.Element(Z, A, I)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*Z*|`number`| Atomic charge number. |
|*A*|`number`| Atomic mass number, in g/mol. |
|*I*|`number`| Mean Excitation Energy (MEE), in GeV. |


### See also

[build](build.md),
[CompositeMaterials](CompositeMaterials.md),
[Material](Material.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).
</div>
