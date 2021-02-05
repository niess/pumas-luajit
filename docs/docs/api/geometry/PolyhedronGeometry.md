# PolyhedronGeometry
_A metatype for representing a constructive geometry using polytopes._


<div markdown="1" class="shaded-box fancy">
## Attributes

None.

!!! note
    The geometry is locked once it has been instanciated. It is the users
    responsibility to keep track of any data he might need. Note however that
    media properties can still me modified, e.g. the density.
    {: .justify}
</div>

<div markdown="1" class="shaded-box fancy">
## Constructor

A [PolyhedronGeometry](PolyhedronGeometry.md) is made as a hierachy of convex
[polyhedron](https://en.wikipedia.org/wiki/Polyhedron)s. The constructor takes a
top (mother) polyhedron as first argument and an optional reference frame. If no
reference frame is provided then the polyhedrons coordinates are assumed to be
defined in the simulation frame.

!!! note
    It is the user's responsibility to ensure that the polyhedrons are indeed
    convex.

### Synopsis

```lua
pumas.PolyhedronGeometry(polyhedron[, frame])
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*polyhedron*|`table`                                 | Top (mother) polyhedron as described below. |
|*frame*     |[Transform](../coordinates/Transform.md)| Reference frame for polyhedrons. If `nil` polyhedrons are assumed to be defined in the simulation frame. |

A convex polyhedron is defined by a constitutive [Medium](../medium/Medium.md)
and by a list of faces delimiting its inner volume. Each face is specified by a
point lying on the face and its outward going normal. In addition the volume can
contain an arbitrary number of daughter polyhedrons. The data of a polyhedron
are provided as a Lua `table` with the following synopsis:
{: .justify}
```lua
polyhedron = {medium, {x, y, z, nx, ny, nz, ...}[, {daughter, ...}]}
```
where the various elements are listed in the table below.

|Name|Type|Description|
|----|----|-----------|
|*medium*  |[Medium](../medium/Medium.md)| Constitutive medium of the polyhedron. |
|*x*       |`number`| Cartesian x (first) coordinate of a point on the face. |
|*y*       |`number`| Cartesian y (second) coordinate of the same point on the face. |
|*z*       |`number`| Cartesian z (third) coordinate of the same point on the face. |
|*nx*      |`number`| Cartesian x (first) coordinate of the outward going normal to the face. |
|*ny*      |`number`| Cartesian y (second) coordinate of the outward going normal to the face. |
|*nz*      |`number`| Cartesian z (third) coordinate of the outward going normal to the face. |
|*daughter*|`table` | A daughter polyhedron (contained inside) following the same semantic. |

!!! note
    The sequence *x*, *y*, *z*, *nx*, *ny* and *nz* is repeated for each face.
    {: .justify}

!!! note
    The daughter polyhedrons must not overlap and must all be contained in
    the mother volume. It is the user's responsibility to ensure that their
    is no overlap.
    {: .justify}

---

### See also

[InfiniteGeometry](InfiniteGeometry.md),
[PolyhedronGeometry](PolyhedronGeometry.md),
[TopographyLayer](TopographyLayer.md),

</div>


<div markdown="1" class="shaded-box fancy">
## PolyhedronGeometry.export

Export the polyhedrons to a file. This method requires an output filename to be
provided as first argument. Extra named options can be specified for the export
as a second `table` argument, e.g. colorization (see below).
{: .justify}

!!! note
    If not explicitly specified the file format for the export is inferred from
    the filename extension.
    {: .justify}

---

### Synopsis

```lua
PolyhedronGeometry:export(path[, {color, format}])
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*path*  |`string`             |Output file for the export.|
|||
|*color* |`table` or `function`|Color of the exported polyhedrons.|
|*format*|`string`             |Format of the exported data. Currently only ['`ply`'](http://paulbourke.net/dataformats/ply/) is supported. |

If the *color* option is provided as a `table` then it must be formated as
`{red, green, blue}` with color values ranging from 0 to 255. The *color* table
can be indexed by number or by color names (`red`, `green` and `blue`).
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

Insert a daughter geometry into the [PolyhedronGeometry](PolyhedronGeometry.md). This
method behaves as the `table.insert` Lua function. If no index is specified
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
|*daughter*|[Geometry](Geometry.md)|Daughter geometry to insert.|

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

Remove a daughter geometry from the [PolyhedronGeometry](PolyhedronGeometry.md) given its
index. If no index is provided the last daughter geometry is removed. This
method behaves as the `table.remove` Lua function.
{: .justify}

---

### Synopsis

```lua
PolyhedronGeometry:remove([index])
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*index*|`number`|Table index of the daughter geometry to remove.|

---

### Returns

|Type|Description|
|----|-----------|
|[Geometry](Geometry.md)| The removed geometry.|

---

### See also

[PolyhedronGeometry.export](#polyhedrongeometryexport),
[PolyhedronGeometry.insert](#poluhedrongeometryinsert).

</div>
