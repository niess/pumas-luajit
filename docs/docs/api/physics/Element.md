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
properties. Its constructor requires three mandatory arguments as detailled in
the synopsis below: the atomic charge, *Z*, the atomic mass, *A* and the Mean
Excitation Energy, *I*, of its electronic structure.
{: .justify}

### Synopsis
```Lua
pumas.Element(Z, A, I)

pumas.Element{Z=, A=, I=}

pumas.Element(element)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*Z*|`number`| Atomic charge number. |
|*A*|`number`| Atomic mass number, in g/mol. |
|*I*|`number`| Mean Excitation Energy (MEE), in GeV. |
||||
|*element*|[Element](Element.md)| Another atomic [Element](Element.md) instance. |


### See also

[build](build.md),
[CompositeMaterials](CompositeMaterials.md),
[dcs](dcs.md),
[elastic](elastic.md),
[Material](Material.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).
</div>
