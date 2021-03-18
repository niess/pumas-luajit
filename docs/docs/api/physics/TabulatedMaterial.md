# TabulatedMaterial
_A metatype exposing the tabulations of a material._


<div markdown="1" class="shaded-box fancy">
## Attributes

A [TabulatedMaterial](TabulatedMaterial.md) is a special instance of a
[Material](Material.md) for which physical properties relevant for the transport
have been pre-computed (tabulated), e.g. the energy loss of the projectile. In
addition to the base attributes of a [Material](Material.md) it has the
following extra attributes:
{: .justify}

|Name|Type|Description|
|----|----|-----------|
|*name*|`string`|Name of the material used e.g. when referring to from a [Medium](../Medium.md). {: .justify} |
|*physics*|[Readonly](../others/Readonly.md)| The [Physics](Physics.md) instance this [TabulatedMaterial](TabulatedMaterial.md) belongs to. {: .justify} |
|*table*|[Readonly](../others/Readonly.md)| Material tabulations ([see below](#table)). |
|||
|*composite*|`boolean`| Flag indicating if the instance is a composite material (`true`) or a base one (`false`). {: .justify} |
|*materials*|[CompositeMaterials](CompositeMaterials.md) or `nil`| For composite materials the [CompositeMaterials](CompositeMaterials.md) table contains the mass fractions of the base materials indexed by name. {: .justify} |

!!! note
    All attributes are [Readonly](../others/Readonly.md), the base
    [Material](Material.md) ones as well as the extra tabulated ones. There is
    one exception though. For composite materials the mass fractions of the
    base materials can be modified (see
    [CompositeMaterials](CompositeMaterials.md)).
    {: .justify}

#### *table*

The *table* attribute contains the physics tabulations organized in three
sub-tables corresponding to the three energy loss modes: `'csda'`, `'detailed'`
and `'hybrid'`. The available tabulations are summarized below, where it must be
understood that *mode* stands for one of *csda*, *detailed* or *hybrid*. E.g.
`table.csda.energy_loss` returns the tabulation of the continuous energy loss
for the CSDA mode. More detailed explanations of the various physical quantities
are also provided hereafter.
{: .justify}

|Name|Type|Description|
|----|----|-----------|
|*(mode).energy\_loss*      |[Readonly](../others/Readonly.md)| Continuous Energy Loss (CEL) per unit grammage, $\frac{dE}{dX}$, in $\text{GeV} \cdot \text{m}^2 \cdot \text{kg}^{-1}$  ([see below](#energy_loss)). {: .justify} |
|*(mode).kinetic\_energy*   |[Readonly](../others/Readonly.md)| Tabulated projectile kinetic energies, $E$, in $\text{GeV}$. |
|*(mode).grammage*          |[Readonly](../others/Readonly.md)| Total grammage for CEL, $X$, in $\text{kg} \cdot \text{m}^{-2}$ ([see below](#grammage)). {: .justify} |
|*(mode).proper\_time*       |[Readonly](../others/Readonly.md)| Total proper time for CEL, $\tau$, assuming a uniform density, in $\text{kg} \cdot \text{m}^{-2}$ ([see below](#proper_time)). {: .justify} |
|||
|*(mode).cross\_section*    |[Readonly](../others/Readonly.md)| Macroscopic cross-section for DELs, $\Sigma$, in m<sup>2</sup>/kg. Available only for `detailed` and `hybrid` modes ([see below](#cross_section)). {: .justify} |

!!! note
    The *detailed* and *hybrid* mode use the same tabulations. For convenience
    both notations can be used. Yet, they actualy refer to the same tables.
    {: .justify}

#### energy\_loss

The simulation of physics interactions is split into two components: Discrete
Energy Losses (DELs) and Continuous Energy Losses (CELs), see [Niess _et al._,
2017](https://arxiv.org/abs/1705.05636) for more details. The splitting is done
using a relative cutoff $\alpha = 5\%$, following [Sokalski _et al._,
2001](https://arxiv.org/abs/hep-ph/0010322). The continuous energy loss per
unit of grammage, $\frac{dE}{dX}$, is given as:
{: .justify}

$$
\frac{dE}{dX} = \frac{\mathcal{N}_A}{A} \int_0^{\alpha E}{q \frac{\partial \sigma(E, q)}{\partial q} dq}
$$

with $E$ the projectile kinetic energy, $\frac{\partial \sigma}{\partial q}$ the
total Differential Cross Section (DCS), $\mathcal{N}_A$ Avogadro number and $A$
the molar mass of the target material.

#### cross\_section

The macroscopic cross-section for DELs, $\Sigma$, is defined per unit mass as:
{: .justify}

$$
\Sigma(E) = \frac{\mathcal{N}_A}{A} \int_{\alpha E}^E{\frac{\partial \sigma(E, q)}{\partial q} dq}
$$

The macroscopic cross-section is related to the interaction length, $\lambda$,
as:
{: .justify}

$$
\lambda = \frac{\rho}{\Sigma}
$$

with $\rho$ the medium density.

#### grammage

In the absence of DEL, the total grammage path length of the projectile is
obtained by integrating its energy loss up to its initial energy, as:
{: .justify}

$$
X(E) = \int_0^E{\frac{1}{\frac{dE}{dX}} dE'}
$$

The previous expression can also been used in order to compute the grammage
variation, $\Delta X$, between two DELs as:
{: .justify}

$$
\Delta X = X(E_1) - X(E_0)
$$

where $E_0$ if the energy after the first DEL and $E_1$ the energy before the
second DEL occurs.
{: .justify}

#### proper\_time

For a uniform density and in the absence of DEL, the total proper time of the
projectile is obtained by integration similarly to the grammage path length.
Per unit mass, it writes:
{: .justify}

$$
\tau(E) = \int_0^E{\frac{1}{\beta \gamma \frac{dE}{dX}} dE'}
$$

In order to get the proper time in unit of time one needs to divide the previous
expression by $\rho c$, i.e. the constant medium density, $\rho$, times the
vacuum speed of light, $c$.
{: .justify}

### See also

[build](build.md),
[CompositeMaterials](CompositeMaterials.md),
[Element](Element.md),
[Material](Material.md),
[Physics](Physics.md).
</div>


<div markdown="1" class="shaded-box fancy">
## TabulatedMaterial.cross\_section

Interpolation of the DELs macroscopic cross section, $\Sigma$, as function of
the projectile kinetic energy, $E$. [See above](#cross_section) for more
details.
{: .justify}

### Synopsis
```Lua
TabulatedMaterial:cross_section(energy)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*energy*|`number`| Kinetic energy of the projectile, in GeV.|

### Returns

|Type|Description|
|----|-----------|
|`number`| The macroscopic cross-section per unit mass, in $\text{m}^2 \cdot \text{kg}^{-1}$ ([see above](#cross_section)).|

### See also

[energy\_loss](#tabulatedmaterialenergy_loss),
[grammage](#tabulatedmaterialgrammage),
[kinetic\_energy](#tabulatedmaterialkinetic_energy),
[magnetic\_rotation](#tabulatedmaterialmagnetic_rotation),
[proper\_time](#tabulatedmaterialproper_time),
[scattering\_length](#tabulatedmaterialscattering_length).
</div>


<div markdown="1" class="shaded-box fancy">
## TabulatedMaterial.energy\_loss

Interpolation of the Continuous Energy Loss (CEL), $\frac{dE}{dX}$, as function
of the projectile kinetic energy, $E$. [See above](#energy_loss) for more
details.
{: .justify}

### Synopsis
```Lua
TabulatedMaterial:energy_loss(energy, (mode))
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*energy*|`number`| Kinetic energy of the projectile, in GeV.|
|*mode*  |`string`| Energy loss mode, one of `'csda'`, `'detailed'` or `'hybrid'`. Defaults to `'csda'`. {: .justify} |

### Returns

|Type|Description|
|----|-----------|
|`number`| The continuous energy loss per unit grammage, in $\text{GeV} \cdot \text{m}^2 \cdot \text{kg}^{-1}$ ([see above](#cross_section)).|

### See also

[cross\_section](#tabulatedmaterialcross_section),
[grammage](#tabulatedmaterialgrammage),
[kinetic\_energy](#tabulatedmaterialkinetic_energy),
[magnetic\_rotation](#tabulatedmaterialmagnetic_rotation),
[proper\_time](#tabulatedmaterialproper_time),
[scattering\_length](#tabulatedmaterialscattering_length).
</div>


<div markdown="1" class="shaded-box fancy">
## TabulatedMaterial.grammage

Interpolation of the total grammage path length, $X$, as function of the
projectile initial kinetic energy, $E$. [See above](#grammage) for more details.
{: .justify}

### Synopsis
```Lua
TabulatedMaterial:grammage(energy, (mode))
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*energy*|`number`| Initial kinetic energy of the projectile, in GeV.|
|*mode*  |`string`| Energy loss mode, one of `'csda'`, `'detailed'` or `'hybrid'`. Defaults to `'csda'`. {: .justify} |

### Returns

|Type|Description|
|----|-----------|
|`number`| The total grammage path length, in $\text{kg} \cdot \text{m}^{-2}$ ([see above](#grammage)).|

### See also

[cross\_section](#tabulatedmaterialcross_section),
[energy\_loss](#tabulatedmaterialenergy_loss),
[kinetic\_energy](#tabulatedmaterialkinetic_energy),
[magnetic\_rotation](#tabulatedmaterialmagnetic_rotation),
[proper\_time](#tabulatedmaterialproper_time),
[scattering\_length](#tabulatedmaterialscattering_length).
</div>


<div markdown="1" class="shaded-box fancy">
## TabulatedMaterial.kinetic\_energy

Interpolation of the projectile initial kinetic energy, $E$, as function of its
total grammage path length, $X$. [See above](#grammage) for more details.
{: .justify}

### Synopsis
```Lua
TabulatedMaterial:kinetic_energy(grammage, (mode))
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*grammage*|`number`| Total grammage path length, in $\text{kg} \cdot \text{m}^{-2}$.|
|*mode*    |`string`| Energy loss mode, one of `'csda'`, `'detailed'` or `'hybrid'`. Defaults to `'csda'`. {: .justify} |

### Returns

|Type|Description|
|----|-----------|
|`number`| The projectile initial kinetic energy, in GeV ([see above](#grammage)).|

### See also

[cross\_section](#tabulatedmaterialcross_section),
[energy\_loss](#tabulatedmaterialenergy_loss),
[grammage](#tabulatedmaterialgrammage),
[magnetic\_rotation](#tabulatedmaterialmagnetic_rotation),
[proper\_time](#tabulatedmaterialproper_time),
[scattering\_length](#tabulatedmaterialscattering_length).
</div>


<div markdown="1" class="shaded-box fancy">
## TabulatedMaterial.magnetic\_rotation

Interpolation of the total rotation angle of the projectile direction, $\Theta$,
due to a constant magnetic field, $B$, as function of its initial kinetic
energy, $E$. For a uniform magnetic field and medium density, $\rho$, if
no DELs occur the rotation angle is related to the total proper time, $\tau$,
as:
{: .justify}

$$
\Theta(E) = \frac{q B}{m} \tau(E)
$$

with $q$ ($m$) the projectile electric charge (rest mass). [See
above](#proper_time) for more details on how the proper time is computed.
{: .justify}

### Synopsis
```Lua
TabulatedMaterial:magnetic_rotation(energy)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*energy*|`number`| Initial kinetic energy of the projectile, in GeV.|

!!! note
    The magnetic rotation is only available for the CSDA mode.
    {: .justify}

### Returns

|Type|Description|
|----|-----------|
|`number`| Total rotation angle, in $\text{rad} \cdot \text{kg} \cdot \text{m}^{-3} \cdot \text{T}^{-1}$. Multiply by the constant magnetic field, $B$, and divide by the uniform medium density, $\rho$, in order to get the angle in radians. {: .justify}|

### See also

[cross\_section](#tabulatedmaterialcross_section),
[energy\_loss](#tabulatedmaterialenergy_loss),
[grammage](#tabulatedmaterialgrammage),
[kinetic\_energy](#tabulatedmaterialkinetic_energy),
[proper\_time](#tabulatedmaterialproper_time),
[scattering\_length](#tabulatedmaterialscattering_length).
</div>


<div markdown="1" class="shaded-box fancy">
## TabulatedMaterial.proper\_time

Interpolation of the total proper time, $\tau$, as function of the projectile
initial kinetic energy, $E$. [See above](#proper_time) for more details.
{: .justify}

### Synopsis
```Lua
TabulatedMaterial:proper_time(energy, (mode))
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*energy*|`number`| Initial kinetic energy of the projectile, in GeV.|
|*mode*  |`string`| Energy loss mode, one of `'csda'`, `'detailed'` or `'hybrid'`. Defaults to `'csda'`. {: .justify} |

### Returns

|Type|Description|
|----|-----------|
|`number`| The total proper time, in $\text{kg} \cdot \text{m}^{-2}$ ([see above](#proper_time)).|

### See also

[cross\_section](#tabulatedmaterialcross_section),
[energy\_loss](#tabulatedmaterialenergy_loss),
[grammage](#tabulatedmaterialgrammage),
[kinetic\_energy](#tabulatedmaterialkinetic_energy),
[magnetic\_rotation](#tabulatedmaterialmagnetic_rotation),
[scattering\_length](#tabulatedmaterialscattering_length).
</div>


<div markdown="1" class="shaded-box fancy">
## TabulatedMaterial.scattering\_length

Compute the first transport path length for Coulomb Multiple Scattering (MS),
$\lambda$, as function of the projectile kinetic energy, $E$. The first path
length is related to the standard deviation of the MS angle as:
{: .justify}

$$
\theta^2 = \frac{X}{2 \lambda}
$$

with $X$ the grammage path length. See [Fernández-Varea _et al._,
1993](https://doi.org/10.1016/0168-583X(93)95827-R), for more details.
{: .justify}

### Synopsis
```Lua
TabulatedMaterial:scattering_length(energy)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*energy*|`number`| Kinetic energy of the projectile, in GeV.|

### Returns

|Type|Description|
|----|-----------|
|`number`| The Coulomb MS first path length, in $\text{kg} \cdot \text{m}^{-2}$.|

### See also

[cross\_section](#tabulatedmaterialcross_section),
[energy\_loss](#tabulatedmaterialenergy_loss),
[grammage](#tabulatedmaterialgrammage),
[kinetic\_energy](#tabulatedmaterialkinetic_energy),
[magnetic\_rotation](#tabulatedmaterialmagnetic_rotation),
[proper\_time](#tabulatedmaterialproper_time).
</div>
