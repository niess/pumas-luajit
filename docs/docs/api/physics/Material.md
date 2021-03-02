# Material
_A metatype for defining materials properties._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*density* |`number`| Material density, in kg/m<sup>3</sup>.|
|*elements*|`table` | Atomic elements composition. The table contains mass fractions indexed with atomic elements symbols. {: .justify}|
|*I*       |`number`| Mean Excitation Energy (MEE), in GeV. |
|*state*   |`string`| Material state. One of `'solid'`, `'liquid'` or `'gas'`. |
|||
|*a*       |`number`| Sternheimer $a$ coefficient ([see below](#constructor)). |
|*k*       |`number`| Sternheimer $k$ coefficient ([see below](#constructor)). |
|*x0*      |`number`| Sternheimer $x_0$ coefficient ([see below](#constructor)). |
|*x1*      |`number`| Sternheimer $x_1$ coefficient ([see below](#constructor)). |
|*Cbar*    |`number`| Sternheimer $\overline{C}$ coefficient ([see below](#constructor)). |
|*delta0*  |`number`| Sternheimer $\delta_0$ coefficient ([see below](#constructor)). |
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
Optionally one can also specify the material Mean Excitation Energy (*I*) and
the material *state* (`'solid'`, `'liquid'` or `'gas'`). If the mean excitation
energy is not provided it is estimated from the atomic composition using Bragg
additivity rule.
{: .justify}

The ionization loss of charged particles depends on the material atomic spacing,
i.e. on its density (see e.g. [Sternheimer et al.,
1984](https://doi.org/10.1016/0092-640X(84)90002-0)). A parameterization of this
effect is provided in [Sternheimer,
1952](https://doi.org/10.1103/PhysRev.88.851) as function of a set of
cooefficients: $a$, $k$, $x_0$, $x_1$ $\overline{C}$ and $\delta_0$. If these
coefficients are not explicitly defined when building the material then their
values will be estimated using the material density and *I* following
[Sternheimer and Peirs, 1971](https://doi.org/10.1103/PhysRevB.3.3681).
{: .justify}

### Synopsis
```Lua
pumas.Material{density=, (elements)=, (formula)=, (I)=, (state)=,
    (a)=, (k)=, (x0)=, (x1)=, (Cbar)=, (delta0)=}
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
|*state*   |`string`| Material state. One of `'solid'`, `'liquid'` or `'gas'`. |
|||
|*a*       |`number`| Sternheimer $a$ coefficient ([see above](#constructor)). |
|*k*       |`number`| Sternheimer $k$ coefficient ([see above](#constructor)). |
|*x0*      |`number`| Sternheimer $x_0$ coefficient ([see above](#constructor)). |
|*x1*      |`number`| Sternheimer $x_1$ coefficient ([see above](#constructor)). |
|*Cbar*    |`number`| Sternheimer $\overline{C}$ coefficient ([see above](#constructor)). |
|*delta0*  |`number`| Sternheimer $\delta_0$ coefficient ([see above](#constructor)). |

### See also

[build](build.md),
[CompositeMaterials](CompositeMaterials.md),
[Element](Element.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).
</div>
