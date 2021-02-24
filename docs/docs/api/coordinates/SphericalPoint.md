# SphericalPoint
_A metatype for representing a 3D point using Spherical coordinates._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*r*    |`double`| Euclidian distance to the origin, in m. |
|*theta*|`double`| &theta; angle counter-clockwise w.r.t. the z-axis, in radians.|
|*phi*  |`double`| &phi; angle counter-clockwise w.r.t. the x-axis, in radians. |
|*frame*|[Transform](Transform.md) or `nil`| Reference frame of the coordinates if different from the simulation one or `nil`.|
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

### Synopsis

```lua
pumas.SphericalPoint(r, theta, phi, frame)

pumas.SphericalPoint{r, theta, phi, frame}

pumas.SphericalPoint(coordinates)
```

!!! note
    For the two first forms the *r*, *theta*, *phi* and *frame* arguments are
    optional, but for the sake of simplicity only the full forms are reported.
    When an argument is missing the corresponding attribute is set to zero or
    `nil`.
    {: .justify}

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*r*    |`number`| Euclidian distance to the origin, in m. |
|*theta*|`number`| &theta; angle counter-clockwise w.r.t. the z-axis, in radians.|
|*phi*  |`number`| &phi; angle counter-clockwise w.r.t. the x-axis, in radians. |
|*frame*|[Transform](Transform.md) or `nil`| Transform representing the reference frame e.g. as returned by [LocalFrame](LocalFrame.md) or `nil` if the coordinates are expressed in the simulation frame.|
||||
|*coordinates*|[Coordinates](../Coordinates.md)| Other point coordinates e.g. as returned by [State.position](../simulation/State.md#attributes). |

### See also

[CartesianPoint](CartesianPoint.md),
[CartesianVector](CartesianVector.md),
[GeodeticPoint](GeodeticPoint.md),
[HorizontalVector](HorizontalVector.md),
[SphericalVector](SphericalVector.md).

</div>


<div markdown="1" class="shaded-box fancy">
## SphericalPoint.clone

Get a copy (clone) of the coordinates instance.

---

### Synopsis

```lua
SphericalPoint:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[SphericalPoint](SphericalPoint.md)| Copy of the point coordinates.|

### See also

[get](#sphericalpointget),
[set](#sphericalpointset),
[transform](#sphericalpointtransform).
</div>


<div markdown="1" class="shaded-box fancy">
## SphericalPoint.get

Get the point coordinates in the simulation frame as a `double [3]` array of
*x*, *y* and *z* Cartesian coordinates. The coordinates are prealably
transformed to the simulation frame if needed, e.g.  if the *frame* attribute is
not `nil`.
{: .justify}

---

### Synopsis

```lua
SphericalPoint:get()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`double [3]`| C array containing the *x*, *y* and *z* coordinates in the simulation frame.|

### See also

[clone](#sphericalpointclone),
[set](#sphericalpointset),
[transform](#sphericalpointtransform).

</div>


<div markdown="1" class="shaded-box fancy">
## SphericalPoint.set

Set the point coordinates from another [Coordinates](../Coordinates.md)
instance.  The input coordinates are transformed to the point frame if needed,
e.g.  if their *frame* attribute differs from the point's one.
{: .justify}

---

### Synopsis

```lua
SphericalPoint:set(coordinates)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*coordinates*|[Coordinates](../Coordinates.md)| Input coordinates.|

!!! note
    The input coordinates must be a point instance
    ([CartesianPoint](CartesianPoint.md), [GeodeticPoint](GeodeticPoint.md),
    [SphericalPoint](SphericalPoint.md)) or a C array, e.g. as returned by
    [State.position](../simulation/State.md#attributes).
    {: .justify}

### Returns

|Type|Description|
|----|-----------|
|[SphericalPoint](SphericalPoint.md)| Reference to the updated coordinates.|

### See also

[clone](#sphericalpointclone),
[get](#sphericalpointget),
[transform](#sphericalpointtransform).
</div>


<div markdown="1" class="shaded-box fancy">
## SphericalPoint.transform

Transform the point coordinates to a new reference frame. The transform occurs
in-place.

---

### Synopsis

```lua
SphericalPoint:transform(frame)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*frame*|[Transform](Transform.md) or `nil`| Transform representing the new frame or `nil` in order to transform to the simulation frame.|

### Returns

|Type|Description|
|----|-----------|
|[SphericalPoint](SphericalPoint.md)| Reference to the updated coordinates.|

### See also

[clone](#sphericalpointclone),
[get](#sphericalpointget),
[set](#sphericalpointset).
</div>
