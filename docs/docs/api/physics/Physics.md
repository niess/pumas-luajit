# Physics
_A metatype for managing physics tabulations._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*composites*    |[Readonly](../others/Readonly.md)|Table of composite [TabulatedMaterials](TabulatedMaterial.md) indexed by name. {: .justify}|
|*cutoff*        |`number`                         |Cutoff value ($x_\text{cut}$) between continuous and discrete energy losses. {: .justify}|
|*elastic\_ratio*|`number`                         |Ratio of the elastic hard path length w.r.t. the first transport path length. {: .justify}|
|*dcs*           |[Readonly](../others/Readonly.md)|Differential Cross-Sections (DCS) for radiative processes ([see below](#dcs)). {: .justify}|
|*elements*      |[Readonly](../others/Readonly.md)|Table of target atomic [Elements](Element.md) used by the physics materials, indexed by atomic symbol. {: .justify}|
|*materials*     |[Readonly](../others/Readonly.md)|Table of base [TabulatedMaterials](TabulatedMaterial.md) indexed by name. {: .justify}|
|*particle*      |[Readonly](../others/Readonly.md)|Properties of the transported (projectile) particle ([see below](#particle)). {: .justify}|

!!! note
    The physics tables and their sub-tables, e.g. [Element](Element.md)
    components of the *elements* table, are all
    [Readonly](../others/Readonly.md). The *cutoff* and *elastic\_ratio*
    attributes cannot be modified as well. They are set when building the
    physics table (see [constructor](#constructor) below or the
    [pumas.build](build.md) function).
    {: .justify}

#### *dcs*

The *dcs* table contains three functions providing the differential
cross-section of radiative processes, as:
{: .justify}

|Name|Type|Description|
|----|----|-----------|
|*bremsstrahlung*  |`function`| Bremsstrahlung differential cross-section, in m<sup>2</sup>.|
|*pair_production* |`function`| Differential cross-section for $e^+e^-$ pair production, in m<sup>2</sup>.|
|*photonuclear*    |`function`| Photonuclear differential cross-section, in m<sup>2</sup>.|

The DCS functions have the following synopsis:
```lua
dcs.process(Z, A, m, K, q)
```
with arguments detailed in the table below:

|Name|Type|Description|
|----|----|-----------|
|*Z*|`number`| Charge number of the target element.|
|*A*|`number`| Mass number of the target element, in g/mol.|
|*m*|`number`| Rest mass of the projectile, in GeV/c<sup>2</sup>.|
|*K*|`number`| Kinetic energy of the projectile, in GeV.|
|*q*|`number`| Energy lost by the projectile, in GeV.|


#### *particle*

The *particle* table contains information on the transported (projectile)
particle, as:

|Name|Type|Description|
|----|----|-----------|
|*lifetime*|`number`| Projectile proper lifetime (decay length), in m/c.|
|*mass*    |`number`| Projectile rest mass, in GeV/c<sup>2</sup>.|
|*name*    |`string`| Particle name, one of `'muon'` or `'tau'`.|
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

pumas.Physics{dedx=, mdf=, particle=, (cutoff)=, (elastic_ratio)=}
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*path*            |`string`| Path to a folder containing pre-computed physics tabulations, e.g. generated with the [build](build.md) function. {: .justify}|
||||
|*dedx*            |`string`| Path to a folder containing energy loss tabulations in the Particle Data Group (PDG) format. {: .justify}|
|*mdf*             |`string`| Path to an XML Material Description File (MDF) describing the target materials, i.e. their atomic composition and physical properties. {: .justify}|
|*particle*        |`string`| Name of the transported (projectile) particle. Must be `'muon'` or `'tau'`. {: .justify}|
|(*cutoff*)        |`number`| Cutoff value between continuous and discrete energy losses. Defaults to 5% which is a good compromise between speed and accuracy for transporting a continuous flux of $\mu$ (see e.g. [Sokalski et al.](https://doi.org/10.1103/PhysRevD.64.074015) or [Koehne et al.](https://doi.org/10.1016/j.cpc.2013.04.001)). {: .justify}|
|(*elastic\_ratio*)|`number`| Ratio of the elastic hard path length w.r.t. the first transport path length. The lower the more detailed the simulation of elastic scattering. Defaults to 1E-04 (see e.g. [Fernandez-Varea et al.](https://doi.org/10.1016/0168-583X(93)95827-R)). {: .justify}|

### See also

[build](build.md),
[CompositeMaterials](CompositeMaterials.md),
[dcs](dcs.md),
[elastic](elastic.md),
[Element](Element.md),
[Material](Material.md),
[TabulatedMaterial](TabulatedMaterial.md).
</div>


<div markdown="1" class="shaded-box fancy">
## Physics.Context

Create a new Monte Carlo simulation [Context](../simulation/Context.md) using
this [Physics](Physics.md).
{: .justify}

---

### Synopsis

```lua
Physics:Context(mode)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|(*mode*)|`string`| Configuration flags for the simulation. The `string` must indicate [Mode](../simulation/Mode.md) attributes flag(s) with proper separator(s) (whitespace, comma, etc.). Default value is `detailed forward`. {: .justify} |

### Returns

|Type|Description|
|----|-----------|
|[Context](../simulation/Context.md)| New Monte Carlo simulation context.|

### See also

[dump](#physicsdump).
</div>


<div markdown="1" class="shaded-box fancy">
## Physics.dump

This method dumps the material tables to a binary file from which they can be
reloaded when building a new [Physics](#constructor) instance. The method takes
a single argument, a filename where to dump the data.
{: .justify}

### Synopsis
```Lua
Physics:dump(path)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*path*|`string`| Filename where to dump the data. If the file already exists it is overwritten.|

### Returns

`nil`

### See also

[Context](#physicscontext).
</div>
