# CartesianPoint
_A metatype for representing a 3D point using Cartesian coordinates._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*x*|`double`| First (x) coordinate, in m. |
|*y*|`double`| Second (y) coordinate, in m.|
|*z*|`double`| Third (z) coordinate, in m. |
|*frame*|[Transform](Transform.md) or `nil`| Reference frame of the coordinates if different from the simulation one or `nil`.|
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

### Synopsis

```lua
pumas.CartesianPoint(x, y, z, frame)

pumas.CartesianPoint{x=, y=, z=, frame=}

pumas.CartesianPoint(coordinates)
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
|*coordinates*|[Coordinates](../Coordinates.md)| Other point coordinates e.g. as returned by [State.position](../simulation/State.md:#attributes). |

### See also

[CartesianVector](CartesianVector.md),
[GeodeticPoint](GeodeticPoint.md),
[HorizontalVector](HorizontalVector.md),
[LocalFrame](LocalFrame.md),
[SphericalPoint](SphericalPoint.md),
[SphericalVector](SphericalVector.md),
[Transform](Transform.md).

</div>


<div markdown="1" class="shaded-box fancy">
## CartesianPoint.clone

Get a copy (clone) of the coordinates instance.

---

### Synopsis

```lua
CartesianPoint:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[CartesianPoint](CartesianPoint.md)| Copy of the point coordinates.|

### See also

[get](#cartesianpointget),
[set](#cartesianpointset),
[transform](#cartesianpointtransform).
</div>


<div markdown="1" class="shaded-box fancy">
## CartesianPoint.get

Get the point coordinates in the simulation frame as a `double [3]` array of
*x*, *y* and *z* Cartesian coordinates. The coordinates are prealably
transformed to the simulation frame if needed, e.g.  if the *frame* attribute is
not `nil`.
{: .justify}

---

### Synopsis

```lua
CartesianPoint:get()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`double [3]`| C array containing the *x*, *y* and *z* coordinates in the simulation frame.|

### See also

[clone](#cartesianpointclone),
[set](#cartesianpointset),
[transform](#cartesianpointtransform).

</div>


<div markdown="1" class="shaded-box fancy">
## CartesianPoint.set

Set the point coordinates from another [Coordinates](../Coordinates.md)
instance.  The input coordinates are transformed to the point frame if needed,
e.g.  if their *frame* attribute differs from the point's one.
{: .justify}

---

### Synopsis

```lua
CartesianPoint:set(coordinates)
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
|[CartesianPoint](CartesianPoint.md)| Reference to the updated coordinates.|

### See also

[clone](#cartesianpointclone),
[get](#cartesianpointget),
[transform](#cartesianpointtransform).
</div>


<div markdown="1" class="shaded-box fancy">
## CartesianPoint.transform

Transform the point coordinates to a new reference frame. The transform occurs
in-place.

---

### Synopsis

```lua
CartesianPoint:transform(frame)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*frame*|[Transform](Transform.md) or `nil`| Transform representing the new frame or `nil` in order to transform to the simulation frame.|

### Returns

|Type|Description|
|----|-----------|
|[CartesianPoint](CartesianPoint.md)| Reference to the updated coordinates.|

### See also

[clone](#cartesianpointclone),
[get](#cartesianpointget),
[set](#cartesianpointset).
</div>
