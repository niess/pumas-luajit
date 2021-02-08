# UniformMedium
_A metatype for describing a medium with uniform properties._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*density*  |`number`    | Bulk density of the medium, in kg/m<sup>3</sup> ([see below](#constructor)). |
|*magnet*   |`double [3]`| Magnetic field Cartesian components in the simulation frame, in T. |
|*material* |`string`    | Name of the filling material. |
</div>

<div markdown="1" class="shaded-box fancy">
## Constructor

The [UniformMedium](UniformMedium.md) wraps a
[TabulatedMaterial](../physics/TabulatedMaterial.md). Optionaly one can specify
an alternative bulk density and/or an extra local magnetic field.
{: .justify}

!!! note
    The ionization loss of charged particles depends on the target material
    atomic spacing, i.e. on its density (see e.g. [Sternheimer et
    al.](https://doi.org/10.1016/0092-640X(84)90002-0)). Therefore, it is *a
    priori* not correct to arbitrarly change the medium density without
    re-computing the energy loss. However, in some cases, e.g. a porous rock
    filled with air, it is a good approximation to use a lower bulk density than
    the material one since the air density (energy loss) is negligible w.r.t.
    the rock one.  For more balanced mixtures, e.g. a porous rock filled with
    water, one should instead use a composite
    [TabulatedMaterial](../physics/TabulatedMaterial.md) and vary the mass
    fractions rather than the medium bulk density.
    {: .justify}

### Synopsis

```lua
pumas.UniformMedium(material, (density), (magnet))
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*material* |`string`    | Name of the filling material. |
|(*density*)|`number`    | Bulk density of the medium, in kg/m<sup>3</sup>. If `nil` then the default material density is used.|
|(*magnet*) |`double [3]`| Magnetic field Cartesian components in the simulation frame, in T. |

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

[GradientMedium](GradientMedium.md),
[transparent\_medium](transparent_medium.md).
</div>
