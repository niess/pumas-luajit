# HorizontalVector
_A metatype for representing a 3D vector using horizontal coordinates._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*norm*     |`double`| Euclidian (&#8467;<sup>2</sup>) norm. |
|*elevation*|`double`| Elevation angle clockwise w.r.t. the xy (horizontal) plane, in radians. |
|*azimuth*  |`double`| Azimuth angle clockwise w.r.t. the y-axis (geographic north), in radians. |
|*frame*|[UnitaryTransformation](UnitaryTransformation.md) or `nil`| Reference frame of the coordinates if different from the simulation one or `nil`.|
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

### Synopsis

```lua
pumas.HorizontalVector(norm, elevation, azimuth, frame)

pumas.HorizontalVector{norm=, elevation=, azimuth=, frame=}

pumas.HorizontalVector(coordinates)
```

!!! note
    For the two first forms the *norm*, *elevation*, *azimuth* and *frame*
    arguments are optional, but for the sake of simplicity only the full forms
    are reported. When an argument is missing the corresponding attribute is set
    to zero or `nil`.
    {: .justify}

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*norm*     |`number` | Euclidian (&#8467;<sup>2</sup>) norm. |
|*elevation*|`number` | Elevation angle clockwise w.r.t. the xy (horizontal) plane, in radians. |
|*azimuth*  |`number` | Azimuth angle clockwise w.r.t. the y-axis (geographic north), in radians. |
|*frame*    |[UnitaryTransformation](UnitaryTransformation.md) or `nil`| UnitaryTransformation representing the reference frame e.g. as returned by [LocalFrame](LocalFrame.md) or `nil` if the coordinates are expressed in the simulation frame.|
||||
|*coordinates*|[Coordinates](../Coordinates.md)| Other vector coordinates e.g. as returned by [State.direction](../simulation/State.md#attributes). |

### See also

[CartesianPoint](CartesianPoint.md),
[CartesianVector](CartesianVector.md),
[GeodeticPoint](GeodeticPoint.md),
[SphericalPoint](SphericalPoint.md),
[SphericalVector](SphericalVector.md).

</div>


<div markdown="1" class="shaded-box fancy">
## HorizontalVector.clone

Get a copy (clone) of the coordinates instance.

---

### Synopsis

```lua
HorizontalVector:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[HorizontalVector](HorizontalVector.md)| Copy of the vector coordinates.|

### See also

[get](#horizontalvectorget),
[set](#horizontalvectorset),
[transform](#horizontalvectortransform).
</div>


<div markdown="1" class="shaded-box fancy">
## HorizontalVector.get

Get the vector coordinates in the simulation frame as a `double [3]` array of
*x*, *y* and *z* Cartesian coordinates. The coordinates are prealably
transformed to the simulation frame if needed, e.g.  if the *frame* attribute is
not `nil`.
{: .justify}

---

### Synopsis

```lua
HorizontalVector:get()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`double [3]`| C array containing the *x*, *y* and *z* coordinates in the simulation frame.|

### See also

[clone](#horizontalvectorclone),
[set](#horizontalvectorset),
[transform](#horizontalvectortransform).

</div>


<div markdown="1" class="shaded-box fancy">
## HorizontalVector.set

Set the vector coordinates from another [Coordinates](../Coordinates.md)
instance.
{: .justify}

---

### Synopsis

```lua
HorizontalVector:set(coordinates)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*coordinates*|[Coordinates](../Coordinates.md)| Input coordinates.|

!!! note
    The input coordinates must be a vector instance
    ([CartesianVector](CartesianVector.md),
    [HorizontalVector](HorizontalVector.md),
    [SphericalVector](SphericalVector.md)) or a C array, e.g. as returned by
    [State.direction](../simulation/State.md#attributes).
    {: .justify}

### Returns

|Type|Description|
|----|-----------|
|[HorizontalVector](HorizontalVector.md)| Reference to the updated coordinates.|

### See also

[clone](#horizontalvectorclone),
[get](#horizontalvectorget),
[transform](#horizontalvectortransform).
</div>


<div markdown="1" class="shaded-box fancy">
## HorizontalVector.transform

Transform the vector coordinates to a new reference frame. The transform occurs
in-place.

---

### Synopsis

```lua
HorizontalVector:transform(frame)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*frame*|[UnitaryTransformation](UnitaryTransformation.md) or `nil`| UnitaryTransformation representing the new frame or `nil` in order to transform to the simulation frame.|

### Returns

|Type|Description|
|----|-----------|
|[HorizontalVector](HorizontalVector.md)| Reference to the updated coordinates.|

### See also

[clone](#horizontalvectorclone),
[get](#horizontalvectorget),
[set](#horizontalvectorset).
</div>
