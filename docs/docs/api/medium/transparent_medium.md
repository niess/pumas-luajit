# transparent\_medium
_A placeholder for an empty medium acting as a container._


## Attributes

|Name|Type|Description|
|----|----|-----------|
|*density*  |`number`| The transparent medium has a null density. |
|*magnet*   |`nil`   | The transparent medium is not locally magnetized. |
|*material* |`nil`   | The transparent medium has no filling material. |

## Description

The [transparent\_medium](transparent_medium.md) is a special
[Medium](../Medium.md) instance that can be used in a [Geometry](../Geometry.md)
in order to indicate the absence of filling medium. When such a medium is
encountered the corresponding volume is ignored.  A transparent volume can still
contain (non transparent) daughters and be included in an other geometry. A
typical usage is to make the top volume of a
[PolyhedronGeometry](../geometry/PolyhedronGeometry.md) transparent such that it
behaves as a bounding box for its content without erasing its own mother
geometry, e.g. an [EarthGeometry](../geometry/EarthGeometry.md) it would be
placed in.
{: .justify}

!!! note
    The [transparent\_medium](transparent_medium.md) should not be mistaken with
    the `nil` medium. The latter indicates the absence of medium at all, i.e.
    the end of the simulation geometry.

---

### See also

[GradientMedium](GradientMedium.md),
[UniformMedium](GradientMedium.md).
</div>
