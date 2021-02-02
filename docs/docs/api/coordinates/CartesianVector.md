# CartesianVector
_A metatype for representing a 3D vector using Cartesian coordinates._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*x*|`double`| First (x) coordinate. |
|*y*|`double`| Second (y) coordinate.|
|*z*|`double`| Third (z) coordinate. |
|*frame*|[Transform](Transform.md) or `nil`| Reference frame of the coordinates if different from the simulation one or `nil`.|
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

### Synopsis

```lua
pumas.CartesianVector(x, y, z, frame)

pumas.CartesianVector{x, y, z, frame}

pumas.CartesianVector(coordinates)
```

!!! note
    For the two first forms the *x*, *y*, *z* and *frame* arguments are
    optional, but for the sake of simplicity only the full forms are reported.
    When an argument is missing the corresponding attribute is set to zero or
    `nil`.
    {: .justify}

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*x*|`number` | First (x) coordinate. |
|*y*|`number` | Second (y) coordinate.|
|*z*|`number` | Third (z) coordinate. |
|*frame*|[Transform](Transform.md) or `nil`| Transform representing the reference frame e.g. as returned by [LocalFrame](LocalFrame.md) or `nil` if the coordinates are expressed in the simulation frame.|
||||
|*coordinates*|[Coordinates](Coordinates.md)| Other vector coordinates e.g. as returned by [State.direction](../simulation/State.md:#attributes). |

### See also

[CartesianPoint](CartesianPoint.md),
[GeodeticPoint](GeodeticPoint.md),
[HorizontalVector](HorizontalVector.md),
[SphericalPoint](SphericalPoint.md),
[SphericalVector](SphericalVector.md).

</div>


<div markdown="1" class="shaded-box fancy">
## CartesianVector.clone

Get a copy (clone) of the coordinates instance.

---

### Synopsis

```lua
CartesianVector:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[CartesianVector](CartesianVector.md)| Copy of the vector coordinates.|

### See also

[CartesianVector.get](#cartesianvectorget),
[CartesianVector.set](#cartesianvectorset),
[CartesianVector.transform](#cartesianvectortransform).
</div>


<div markdown="1" class="shaded-box fancy">
## CartesianVector.get

Get the vector coordinates in the simulation frame as a `double [3]` array of
*x*, *y* and *z* Cartesian coordinates. The coordinates are prealably
transformed to the simulation frame if needed, e.g.  if the *frame* attribute is
not `nil`.
{: .justify}

---

### Synopsis

```lua
CartesianVector:get()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`double [3]`| C array containing the *x*, *y* and *z* coordinates in the simulation frame.|

### See also

[CartesianVector.clone](#cartesianvectorclone),
[CartesianVector.set](#cartesianvectorset),
[CartesianVector.transform](#cartesianvectortransform).

</div>


<div markdown="1" class="shaded-box fancy">
## CartesianVector.set

Set the vector coordinates from another [Coordinates](Coordinates.md) instance
The input coordinates are transformed to the vector frame if needed, e.g.  if
their *frame* attribute differs from the vector's one.
{: .justify}

---

### Synopsis

```lua
CartesianVector:set(coordinates)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*coordinates*|[Coordinates](Coordinates.md)| Input coordinates.|

!!! note
    The input coordinates must be a vector instance
    ([CartesianVector](CartesianVector.md), [HorizontalVector](HorizontalVector.md),
    [SphericalVector](SphericalVector.md)) or a C array, e.g. as returned by
    [State.direction](../simulation/State.md#attributes).
    {: .justify}

### Returns

|Type|Description|
|----|-----------|
|[CartesianVector](CartesianVector.md)| Reference to the updated coordinates.|

### See also

[CartesianVector.clone](#cartesianvectorclone),
[CartesianVector.get](#cartesianvectorget),
[CartesianVector.transform](#cartesianvectortransform).
</div>


<div markdown="1" class="shaded-box fancy">
## CartesianVector.transform

Transform the vector coordinates to a new reference frame. The transform occurs
in-place.

---

### Synopsis

```lua
CartesianVector:transform(frame)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*frame*|[Transform](Transform.md) or `nil`| Transform representing the new frame or `nil` in order to transform to the simulation frame.|

### Returns

|Type|Description|
|----|-----------|
|[CartesianVector](CartesianVector.md)| Reference to the updated coordinates.|

### See also

[CartesianVector.clone](#cartesianvectorclone),
[CartesianVector.get](#cartesianvectorget),
[CartesianVector.set](#cartesianvectorset),
</div>
