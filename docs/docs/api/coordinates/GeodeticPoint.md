# GeodeticPoint
_A metatype for representing a 3D point using geodetic coordinates._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*latitude* |`double`| Geodetic latitude, in deg. |
|*longitude*|`double`| Geodetic longitude, in deg.|
|*altitude* |`double`| Altitude w.r.t. the WGS84 ellipsoid, in m. |

!!! note
    Geodetic coordinates are w.r.t. the WGS84 ellipsoid, e.g. as GPS
    coordinates.  In order to get the altitude w.r.t. the sea level one must
    correct from the geoid undulations.
    {: .justify}
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

### Synopsis

```lua
pumas.GeodeticPoint(latitude, longitude, altitude)

pumas.GeodeticPoint{latitude=, longitude=, altitude=}

pumas.GeodeticPoint(coordinates)
```

!!! note
    For the two first forms the *latitude*, *longitude* and *altitude* arguments
    are optional, but for the sake of simplicity only the full forms are
    reported. When an argument is missing the corresponding attribute is set to
    zero.
    {: .justify}

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*latitude* |`number` | Geodetic latitude, in deg. |
|*longitude*|`number` | Geodetic longitude, in deg.|
|*altitude* |`number` | Altitude w.r.t. the WGS84 ellipsoid, in m. |
||||
|*coordinates*|[Coordinates](../Coordinates.md)| Other point coordinates e.g. as returned by [State.position](../simulation/State.md#attributes). |

---

### See also

[CartesianPoint](CartesianPoint.md),
[CartesianVector](CartesianVector.md),
[HorizontalVector](HorizontalVector.md),
[SphericalPoint](SphericalPoint.md),
[SphericalVector](SphericalVector.md).

</div>


<div markdown="1" class="shaded-box fancy">
## GeodeticPoint.clone

Get a copy (clone) of the coordinates instance.

---

### Synopsis

```lua
GeodeticPoint:clone()
```

---

### Arguments

None, except *self*.

---

### Returns

|Type|Description|
|----|-----------|
|[GeodeticPoint](GeodeticPoint.md)| Copy of the point coordinates.|

---

### See also

[get](#geodeticpointget),
[set](#geodeticpointset).
</div>


<div markdown="1" class="shaded-box fancy">
## GeodeticPoint.get

Get the point coordinates as a `double [3]` array of *x*, *y* and *z*
Cartesian coordinates. The coordinates are given in the Earth-Centered
Earth-Fixed (ECEF) reference frame.
{: .justify}

---

### Synopsis

```lua
GeodeticPoint:get()
```

---

### Arguments

None, except *self*.

---

### Returns

|Type|Description|
|----|-----------|
|`double [3]`| C array containing the *x*, *y* and *z* coordinates in the ECEF frame.|

---

### See also

[clone](#geodeticpointclone),
[set](#geodeticpointset).

</div>


<div markdown="1" class="shaded-box fancy">
## GeodeticPoint.set

Set the point coordinates from another [Coordinates](../Coordinates.md) instance
The input coordinates are transformed to the ECEF frame if needed, e.g.  if
their *frame* attribute is not `nil`.
{: .justify}

---

### Synopsis

```lua
GeodeticPoint:set(coordinates)
```

---

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

---

### Returns

|Type|Description|
|----|-----------|
|[GeodeticPoint](GeodeticPoint.md)| Reference to the updated coordinates.|

---

### See also

[clone](#geodeticpointclone),
[get](#geodeticpointget).
</div>
