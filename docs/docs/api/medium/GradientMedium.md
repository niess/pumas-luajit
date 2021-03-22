# GradientMedium
_A metatype for describing a medium with a density gradient._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*axis*       |`double [3]` or `string`| Cartesian coordinates of the gradient axis in the simulation frame or `'vertical'` if the gradient axis is defined by the Earth local vertical. |
|*lambda*     |`number`                | Gradient $\lambda$ parameter, in m ([see below](#constructor)). |
|*magnet*     |`double [3]`            | Magnetic field Cartesian components in the simulation frame, in T. |
|*material*   |`string`                | Name of the filling material. |
|*name*       |`string` or `nil`       | An optional name for labelling the medium. {: .justify} |
|*rho&Oslash;*|`number`                | Gradient $\rho_0$ parameter, in kg/m<sup>3</sup> ([see below](#constructor)). |
|*type*       |`string`                | Gradient type, i.e. `'linear'` or `'exponential'`. |
|*z&Oslash;*  |`number`                | Gradient $z_0$ parameter, in m ([see below](#constructor)). |
</div>

<div markdown="1" class="shaded-box fancy">
## Constructor

The [GradientMedium](GradientMedium.md) allows to apply a unidimensional density
gradient to a [TabulatedMaterial](../physics/TabulatedMaterial.md). Two types of
gradient are available: linear or exponential. The parameters $\rho_0$, $z_0$
and $\lambda$ of the gradient are defined as:
{: .justify}

$$
\begin{aligned}
\rho(z) &= \rho_0 \left( 1 + \frac{z - z_0}{\lambda} \right) \\
\rho(z) &= \rho_0 \exp\left(\frac{z - z_0}{\lambda}\right)
\end{aligned}
$$

where the first equation stands for a linear gradient and the second for an
exponential one. The gradient axis is defined by a unit vector $\vec{u}_g$.
The $z$ coordinate corresponds to the location along this axis as $z = \vec{r}
\cdot \vec{u}_g$. The gradient axis can be set to an absolute direction in the
simulation frame or to the Earth local vertical. Optionaly one can also specify
an extra local magnetic field.
{: .justify}

!!! warning
    The ionization loss of charged particles depends on the target material
    atomic spacing, i.e. on its density (see e.g. [Sternheimer et al.,
    1984](https://doi.org/10.1016/0092-640X(84)90002-0)). Therefore, it is *a
    priori* not correct to arbitrarly change the medium density without
    re-computing the energy loss. However, this is a next to leading order
    effect compared to the density variation itself. Therefore, in some cases
    e.g. when modelling the atmosphere whose density (energy loss) is small
    w.r.t. to rocks, this can be a convenient approximation.
    {: .justify}

### Synopsis

```lua
pumas.GradientMedium(
    material, {lambda=, (axis)=, (magnet)=, (name)=, (rho0)=}, (type)=, (z0)=})
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*material*     |`string`                         | Name of the filling material. |
|*lambda*       |`number`                         | Gradient $\lambda$ parameter, in m ([see above](#constructor)). |
|||
|(*axis*)       |[Coordinates](../Coordinates.md), `table` or `string`| Coordinates of the gradient axis in the simulation frame or `'vertical'` if the gradient axis is defined by the Earth local vertical. Defaults to `'vertical'`. {: .justify} |
|(*magnet*)     |[Coordinates](../Coordinates.md) or `table`| Magnetic field coordinates in the simulation frame, in T. Defaults to `{0, 0, 0}` T. {: .justify} |
|(*name*)       |`string`                         | An optional name for labelling the medium. {: .justify} |
|(*rho&Oslash;*)|`number`                         | Gradient $\rho_0$ parameter, in kg/m<sup>3</sup> ([see above](#constructor)). Defaults to the *material*'s density. {: .justify} |
|(*type*)       |`string`                         | Gradient type, i.e. `'linear'` or `'exponential'`. Defaults to `'exponential'`. {: .justify} |
|(*z&Oslash;*)  |`number`                         | Gradient $z_0$ parameter, in m ([see above](#constructor)). Defaults to zero. {: .justify} |

!!! note
    The filling material must reference a
    [TabulatedMaterial](../physics/TabulatedMaterial.md) of the
    [Physics](../physics/Physics.md) used for the simulation.
    {: .justify}

!!! note
    The local magnetic field is superimposed over (added to) any magnetic field
    defined by the geometry.
    {: .justify}

---

### See also

[transparent\_medium](transparent_medium.md),
[UniformMedium](UniformMedium.md).
</div>


<div markdown="1" class="shaded-box fancy">
## GradientMedium.density

Get the medium density, in $\text{kg} / \text{m}^3$, at a given location.
The location can be provided as a [Coordinates](../Coordinates.md) object or
as a simulation [State](../simulation/State.md) object. In the latter case the
[`state.position`](../simulation/State.md#attributes) is considered for the
location.
{: .justify}

### Synopsis
```Lua
GradientMedium:density(state)

GradientMedium:density(coordinates)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*state*|[State](../simulation/State.md)| Simulation state. The `state.position` is considered for the  computation of the density value. {: .justify}|
||||
|*coordinates* |[Coordinates](../Coordinates.md)| Point coordinates, in m. {: .justify}|


### Returns

|Type|Description|
|----|-----------|
|`number`| Medium density at the requested location, in $\text{kg} / \text{m}^3$. {: .justify}|
</div>
