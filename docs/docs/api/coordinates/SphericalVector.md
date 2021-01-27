# SphericalVector
_A metatype for representing a 3D vector using spherical coordinates._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*norm* |`double`| Euclidian (&#8467;<sup>2</sup>) norm. |
|*theta*|`double`| &theta; angle counter-clockwise w.r.t. the z-axis, in radians.|
|*phi*  |`double`| &phi; angle counter-clockwise w.r.t. the x-axis, in radians. |
|*frame*|[Transform](Transform.md) or `nil`| Reference frame of the coordinates if different from the simulation one or `nil`.|
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

### Synopsis

```lua
pumas.SphericalVector(x, y, z, frame)

pumas.SphericalVector{x, y, z, frame}

pumas.SphericalVector(coordinates)
```

!!! note
    For the two first forms the *norm*, *theta*, *phi* and *frame* arguments are
    optional, but for the sake of simplicity only the full forms are reported.
    When an argument is missing the corresponding attribute is set to zero or
    `nil`.
    {: .justify}

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*norm* |`number` | Euclidian (&#8467;<sup>2</sup>) norm. |
|*theta*|`double`| &theta; angle counter-clockwise w.r.t. the z-axis, in radians.|
|*phi*  |`double`| &phi; angle counter-clockwise w.r.t. the x-axis, in radians. |
|*frame*|[Transform](Transform.md) or `nil`| Transform representing the reference frame e.g. as returned by [LocalFrame](LocalFrame.md) or `nil` if the coordinates are expressed in the simulation frame.|
||||
|*coordinates*|`Coordinates` or `double [3]`| Another Coordinates instance or a C array of coordinates, e.g. as returned by [State.direction](../simulation/State.md:#attributes). |

### See also

[CartesianPoint](CartesianPoint.md),
[CartesianVector](CartesianVector.md),
[GeodeticPoint](GeodeticPoint.md),
[HorizontalVector](HorizontalVector.md),
[SphericalPoint](SphericalPoint.md).
</div>


<div markdown="1" class="shaded-box fancy">
## SphericalVector.clone

Get a copy (clone) of the coordinates instance.

---

### Synopsis

```lua
SphericalVector:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[SphericalVector](SphericalVector.md)| Copy of the vector coordinates.|

### See also

[SphericalVector.get](#sphericalvectorget),
[SphericalVector.set](#sphericalvectorset),
[SphericalVector.transform](#sphericalvectortransform).
</div>


<div markdown="1" class="shaded-box fancy">
## SphericalVector.get

Get the vector coordinates in the simulation frame as a `double [3]` array of
*x*, *y* and *z* Cartesian coordinates. The coordinates are prealably
transformed to the simulation frame if needed, i.e.  if the *frame* attribute is
not `nil`.
{: .justify}

---

### Synopsis

```lua
SphericalVector:get()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`double [3]`| C array containing the *x*, *y* and *z* coordinates in the simulation frame.|

### See also

[SphericalVector.clone](#sphericalvectorclone),
[SphericalVector.set](#sphericalvectorset),
[SphericalVector.transform](#sphericalvectortransform).

</div>


<div markdown="1" class="shaded-box fancy">
## SphericalVector.set

Set the vector coordinates from another Coordinates instance or from a `double [3]`
array of *x*, *y* and *z* Cartesian coordinates in the simulation frame. The
input coordinates are transformed to the vector frame if needed, i.e.  if their
*frame* attribute differs from the vector's one.
{: .justify}

---

### Synopsis

```lua
SphericalVector:set(coordinates)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*coordinates*|`Coordinates` or `double [3]`| Input coordinates.|

!!! note
    The input coordinates must be a vector instance
    ([CartesianVector](CartesianVector.md), [HorizontalVector](HorizontalVector.md),
    [SphericalVector](SphericalVector.md)) or a C array, e.g. as returned by
    [State.direction](../simulation/State.md#attributes).
    {: .justify}

### Returns

|Type|Description|
|----|-----------|
|[SphericalVector](SphericalVector.md)| Reference to the updated coordinates.|

### See also

[SphericalVector.clone](#sphericalvectorclone),
[SphericalVector.get](#sphericalvectorget),
[SphericalVector.transform](#sphericalvectortransform).
</div>


<div markdown="1" class="shaded-box fancy">
## SphericalVector.transform

Transform the vector coordinates to a new reference frame. The transform occurs
in-place.

---

### Synopsis

```lua
SphericalVector:transform(frame)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*frame*|[Transform](Transform.md) or `nil`| Transform representing the new frame or `nil` in order to transform to the simulation frame.|

### Returns

|Type|Description|
|----|-----------|
|[SphericalVector](SphericalVector.md)| Reference to the updated coordinates.|

### See also

[SphericalVector.clone](#sphericalvectorclone),
[SphericalVector.get](#sphericalvectorget),
[SphericalVector.set](#sphericalvectorset),
</div>
