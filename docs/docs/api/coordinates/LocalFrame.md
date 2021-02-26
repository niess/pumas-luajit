# LocalFrame
_Coordinates transform representing a local Earth frame._

The [LocalFrame](LocalFrame.md) constructor creates a
[UnitaryTransformation](UnitaryTransformation.md) representing a local Earth
frame at a given location (*origin*). By default the $x$-axis points to the
geographic east, the $y$-axis to the geographic north and the $z$-axis
corresponds to the local vertical.  Optionally *declination* and *inclination*
angles can be specified, e.g. in order to orient the local frame along the
geo-magnetic north instead.
{: .justify}

## Synopsis
``` lua
pumas.LocalFrame(origin, {(declination)=, (inclination)=})
```

## Arguments

|Name|Type|Description|
|----|----|-----------|
|*origin*     |[Coordinates](../Coordinates.md)| Location (origin) of the local Earth frame.|
|*declination*|`number`| Declination angle, in deg, positively measured toward the east. {: .justify}|
|*inclination*|`number`| Inclination angle, in deg, positively measured downwards. {: .justify}|

!!! note
    The *declination* angle corresponds to a rotation around the local vertical
    ($z$-axis). It is positive for a rotation towards the east. The
    *inclination* angle corresponds to a second intrinsic rotation around the
    $x'$-axis of the rotated frame. It is positive for a downward rotation.
    {: .justify}

## Returns

|Type|Description|
|----|-----------|
|[UnitaryTransformation](UnitaryTransformation.md)| UnitaryTransformation representing the local Earth frame.|

## Examples

``` lua
local origin = pumas.GeodeticPoint(latitude, longitude, altitude)
local frame = pumas.LocalFrame(origin)
```

## See also

[UnitaryTransformation](UnitaryTransformation.md)
