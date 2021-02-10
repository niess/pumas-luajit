# PolyhedronGeometry
_A metatype for representing a constructive geometry using polyhedrons._


<div markdown="1" class="shaded-box fancy">
## Attributes

None.

!!! note
    The geometry is locked once it has been instanciated. However
    media properties can still be modified, e.g. their density.
    {: .justify}
</div>

<div markdown="1" class="shaded-box fancy">
## Constructor

A [PolyhedronGeometry](PolyhedronGeometry.md) is a hierarchy of convex
[polyhedrons](https://en.wikipedia.org/wiki/Polyhedron). The constructor takes a
top (mother) polyhedron as first argument and an optional reference frame. If no
reference frame is provided then the polyhedrons coordinates are assumed to be
defined in the simulation frame.
{: .justify}

!!! note
    It is the user's responsibility to ensure that the polyhedrons are indeed
    convex.
    {: .justify}

### Synopsis

```lua
pumas.PolyhedronGeometry(polyhedron, (frame))
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*polyhedron*|`table`                                 | Top (mother) polyhedron as described below. |
|(*frame*)   |[Transform](../coordinates/Transform.md)| Reference frame for polyhedrons. If `nil` polyhedrons are assumed to be defined in the simulation frame. |

A convex polyhedron is defined by a filling [Medium](../medium/Medium.md) and by
a list of faces delimiting its inner volume. Each face is specified by a point
lying on the face and by a unit normal vector, outward going. In addition the
volume can contain an arbitrary number of daughter polyhedrons. The data of a
polyhedron are provided as a Lua `table` with the following synopsis:
{: .justify}
```lua
polyhedron = {medium, {x, y, z, nx, ny, nz, ...}, {(daughter), ...}}
```
where the various elements are listed in the table below.

|Name|Type|Description|
|----|----|-----------|
|*medium*|[Medium](../medium/Medium.md) or `string`| Filling medium of the polyhedron. If a `string` is provided it must reference a [TabulatedMaterial](../physics/TabulatedMaterial.md). Then a [UniformMedium](../medium/UniformMedium.md) is implicitly created and filled with the corresponding material. {: .justify}|
|*x*         |`number`| Cartesian x (first) coordinate of a point on the face, in m. |
|*y*         |`number`| Cartesian y (second) coordinate of the same point on the face, in m. |
|*z*         |`number`| Cartesian z (third) coordinate of the same point on the face, in m. |
|*nx*        |`number`| Cartesian x (first) coordinate of the normal to the face, outward going. |
|*ny*        |`number`| Cartesian y (second) coordinate of the normal to the face, outward going. {: .justify} |
|*nz*        |`number`| Cartesian z (third) coordinate of the normal to the face, outward going. {: .justify} |
|(*daughter*)|`table` | A daughter polyhedron contained inside and following the same semantic. {: .justify} |

!!! note
    The sequence *x*, *y*, *z*, *nx*, *ny* and *nz* has to be repeated for each
    face.
    {: .justify}

!!! note
    The daughter polyhedrons must not overlap and must all be contained in
    the mother volume. It is the user's responsibility to ensure that there
    is no overlap.
    {: .justify}

---

### See also

[InfiniteGeometry](InfiniteGeometry.md),
[PolyhedronGeometry](PolyhedronGeometry.md),
[TopographyLayer](TopographyLayer.md).

</div>


<div markdown="1" class="shaded-box fancy">
## PolyhedronGeometry.export

Export the polyhedrons to a file. This method requires an output filename to be
provided as first argument. Extra keyword options can be specified for the
export in a second `table` argument, e.g. colorization (see below).
{: .justify}

!!! note
    If not explicitly specified the file format for the export is inferred from
    the extension of the output filename.
    {: .justify}

---

### Synopsis

```lua
PolyhedronGeometry:export(path, {(color)=, (format)=})
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*path*    |`string`             |Output file for the export.|
|||
|(*color*) |`table` or `function`|Color of the exported polyhedrons.|
|(*format*)|`string`             |Format of the exported data. Currently only ['`ply`'](http://paulbourke.net/dataformats/ply/) is supported. |

If the *color* option is provided as a `table` then it must be formated as
`{red, green, blue}` with color values ranging from 0 to 255. The *color* table
can be indexed by number or by color names (`{red=, green=, blue=}`).
Alternatively one can also provide a painter callback `function` with the
following synopsis: `color(medium)` where *medium* is a constitutive
[Medium](../medium/Medium.md) of the
[PolyhedronGeometry](PolyhedronGeometry.md).  This function must return three
numbers in the range 0 to 255 indicating the the color code to apply to the
corresponding medium.
{: .justify}

---

### Returns

`nil`

---

### See also

[PolyhedronGeometry.insert](#polyhedrongeometryinsert),
[PolyhedronGeometry.remove](#polyhedrongeometryremove).
</div>


<div markdown="1" class="shaded-box fancy">
## PolyhedronGeometry.insert

Insert a daughter geometry into the [PolyhedronGeometry](PolyhedronGeometry.md).
This method behaves as the `table.insert` Lua function. If no index is specified
the daughter geometry is appended as the last element.
{: .justify}

---

### Synopsis

```lua
PolyhedronGeometry:insert(daughter)

PolyhedronGeometry:insert(index, daughter)
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*index*|`number`|Table index of the inserted geometry.|
|*daughter*|[Geometry](../Geometry.md)|Daughter geometry to insert.|

---

### Returns

`nil`

---

### See also

[PolyhedronGeometry.export](#polyhedrongeometryexport),
[PolyhedronGeometry.remove](#polyhedrongeometryremove).
</div>


<div markdown="1" class="shaded-box fancy">
## PolyhedronGeometry.remove

Remove a daughter geometry from the [PolyhedronGeometry](PolyhedronGeometry.md)
given its index. If no index is provided the last daughter geometry is removed.
This method behaves as the `table.remove` Lua function.
{: .justify}

---

### Synopsis

```lua
PolyhedronGeometry:remove((index))
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|(*index*)|`number`|Table index of the daughter geometry to remove.|

---

### Returns

|Type|Description|
|----|-----------|
|[Geometry](../Geometry.md)| The removed geometry.|

---

### See also

[PolyhedronGeometry.export](#polyhedrongeometryexport),
[PolyhedronGeometry.insert](#poluhedrongeometryinsert).

</div>
