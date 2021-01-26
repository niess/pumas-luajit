# CartesianPoint
_A metatype for representing a 3D point using Cartesian coordinates._


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
pumas.CartesianPoint(x, y, z, frame)

pumas.CartesianPoint{x, y, z, frame}

pumas.CartesianPoint(c_array)
```

!!! note
    For the two first forms the x, y, z and frame arguments are optional, but
    for the sake of simplicity only the full forms are reported. When an
    argument is missing the corresponding attribute is set to zero or `nil`.
    {: .justify}

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*x*|`number` | First (x) coordinate. |
|*y*|`number` | Second (y) coordinate.|
|*z*|`number` | Third (z) coordinate. |
|*frame*|[Transform](Transform.md) or `nil`| Reference frame e.g. as returned by [LocalFrame](LocalFrame.md) or `nil` if the coordinates are expressed in the simulation frame.|
||||
|*c_array*|`double [3]`| C array of coordinates, e.g. as returned by [State.position](State.md:#attributes). |


### Returns

---

### See also

[CartesianVector](CartesianVector.md),
[GeodeticPoint](GeodeticPoint.md),
[HorizontalVector](HorizontalVector.md),
[SphericalPoint](SphericalPoint.md),
[SphericalVector](SphericalVector.md).

</div>


<div markdown="1" class="shaded-box fancy">
## CartesianPoint.get

Get the point coordinates in the simulation frame as a `double [3]` array of
*x*, *y* and *z* Cartesian coordinates. The coordinates are prealably
transformed to the simulation frame if needed, i.e.  if the *frame* attribute is
not `nil`.
{: .justify}

---

### Synopsis

```lua
CartesianCoordinates:get()
```

---

### Arguments

None, except *self*.

---

### Returns

|Type|Description|
|----|-----------|
|`double [3]`| A C array containing the *x*, *y* and *z* coordinates in the simulation frame.|

---

### See also

[CartesianPoint.set](#cartesianpointset),
[CartesianPoint.transform](#cartesianpointtransform).

</div>


<div markdown="1" class="shaded-box fancy">
## CartesianPoint.set

Set the point coordinates from another Coordinates instance or from a `double [3]`
array of *x*, *y* and *z* Cartesian coordinates in the simulation frame. The
input coordinates are transformed to the point frame if needed, i.e.  if the
*frame* attribute is not `nil`.
{: .justify}

---

### Synopsis

```lua
CartesianPoint:set(coordinates)
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*coordinates*|`Coordinates` or `double [3]`| Input coordinates.|

!!! note
    The input coordinates must be a point instance
    ([CartesianPoint](CartesianPoint.md), [GeodeticPoint](GeodeticPoint.md),
    [SphericalPoint](SphericalPoint.md)) or a C array, e.g. as returned by
    [State.position](#State.md#attributes).
    {: .justify}

---

### Returns

|Type|Description|
|----|-----------|
|[CartesianPoint](CartesianPoint.md)| A reference to the updated coordinates.|

---

### See also

[CartesianPoint.get](#cartesianpointget),
[CartesianPoint.transform](#cartesianpointtransform).
</div>


<div markdown="1" class="shaded-box fancy">
## CartesianPoint.transform

---

### Synopsis

---

### Arguments

---

### Returns


---

### See also

</div>