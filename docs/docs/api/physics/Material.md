# Material
_A metatype for defining materials properties._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*density* |`number`| Material density, in kg/m<sup>3</sup>.|
|*elements*|`table` | Atomic elements composition. The table contains mass fractions indexed with atomic elements symbols. {: .justify}|
|*I*       |`number`| Mean Excitation Energy (MEE), in GeV. |
|||
|*ZoA*     |`number`| The ratio $Z / A$ of the charge number over the mass number (g/mol) averaged over atomic components. {: .justify} |
</div>

!!! note
    The *ZoA* attribute is informative only. Changing its value has no effect
    on the material properties.
    {: .justify}

<div markdown="1" class="shaded-box fancy">
## Constructor

The [Material](Material.md) constructor takes a single table argument specifying
the material properties as keywords. A material is defined by its *density* and
its atomic composition. The atomic composition can be provided by a chemical
formula or as a `table` of mass fractions indexed with atomic elements symbols.
Optionally one can also specify the material Mean Excitation Energy (*I*).  If
the mean excitation energy is not provided it is estimated from the atomic
composition using Bragg additivity rule.
{: .justify}

!!! note
    The ionization loss of charged particles depends on the material dielectric
    properties, a.k.a. the "density effect" (see e.g. [Fermi,
    1940](https://doi.org/10.1103/PhysRev.57.485)). For relativistic
    projectiles, due to screening effects, the denser the medium the less the
    energy loss for a same number of target atoms.
    {: .justify}

### Synopsis
```Lua
pumas.Material{density=, (elements)=, (formula)=, (I)=}
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*density* |`number`| Material density, in kg/m<sup>3</sup>.|
|||
|*elements*|`table` | Atomic elements composition. The table contains mass fractions indexed with atomic elements symbols. {: .justify}|
|*formula* |`string`| Chemical formula, e.g. `'H2O'`.|
|||
|*I*       |`number`| Mean Excitation Energy (MEE), in GeV. |

### See also

[build](build.md),
[CompositeMaterials](CompositeMaterials.md),
[dcs](dcs.md),
[elastic](elastic.md),
[Element](Element.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).
</div>
