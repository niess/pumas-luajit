# Coordinates
_Generic coordinates for 3D points and vectors._

## Description

[Coordinates](Coordinates.md) are a group of metatypes representing a point or a
vector using a specific coordinates system and reference frame. These metatypes
transform to each another in order to consistently represent the same point or
vector of the 3D simulation space. Function arguments reported as
[Coordinates](Coordinates.md) can be of any metatype of the group.
{: .justify}

The PUMAS library uses Cartesian coordinates for the simulation with a unique
frame, referred to as the *simulation frame*. These coordinates are stored using
a `double [3]` C array, see e.g. the *position* and *direction* attributes of a
simulation [State](simulation/State.md#attributes).  The `double [3]` array is a
basic representation of a point or vector using Cartesian coordinates.  Higher
level representations are provided as
[CartesianPoint](coordinates/CartesianPoint.md) or
[CartesianVector](coordinates/CartesianVector.md).  These representations make
explicit the point or vector type of the represented object. In addition to the
*x*, *y* and *z* attributes, these object also have a *frame* attribute
specifying the reference frame used by the coordinates. The absence of reference
frame (`nil`) indicates that the coordinates are expressed in the simulation
frame. Reference frames as specified as
[UnitaryTransformation](coordinates/UnitaryTransformation.md) objects w.r.t. the
simulation frame.
{: .justify}

#### Earth coordinates

The [GeodeticPoint](coordinates/GeodeticPoint.md) metatype allows to represent
an Earth location using its latitude, longitude and altitude w.r.t. the WGS84
ellipsoid.  Note that this object does not have a *frame* attribute since it
uses a fixed frame (see below). Local Earth frames can be created with the
[LocalFrame](coordinates/LocalFrame.md) frame constructor by specifying an
origin on Earth.  Then, the [HorizontalVector](coordinates/HorizontalVector.md)
mettaype can be used to represent a direction in the local frame using
horizontal coordinates, i.e. by specifying an azimuth and an elevation angle.
{: .justify}

!!! warning
    When using a [GeodeticPoint](coordinates/GeodeticPoint.md) or a
    [LocalFrame](coordinates/LocalFrame.md) the simulation frame is assumed to
    be Earh-Centered, Earth-Fixed (ECEF). Using a different simulation frame
    together with the latter objects will lead to erroneous results.
    {: .justify}

#### Converting

[Coordinates](Coordinates.md) instances can be cast into each another using
their respective constructors or converted in-place with the `Coordinates.set`
method. There is one exception, though. Coordinates metatypes can not be cast to
a `double [3]` array since this type does not have a specific constructor.
Instead one must use the `Coordinates.get` method in order to convert a point or
vector to its basic representation.
{: .justify}

Changing the coordinates to a new reference frame is done with the
`Coordinates.transform` method. The change occurs in-place, i.e. the coordinates
and frame of the initial object are updated. If a copy is desired instead it
must be done explicitly beforehand, e.g. with the `Coordinates.clone` method.
{: .justify}

!!! note
    Changing the *frame* attribute of a [Coordinates](Coordinates.md) object
    does not change the coordinates values but only the reference frame. One
    must explictly use the `Coordinates.transform` method if the intent is to
    change the coordinates to another frame, i.e. refer to the same point or
    vector but using another reference frame.
    {: .justify}

## Examples

```lua
-- Get the simulation position in geodetic coordinates
local position = pumas.GeodeticPoint(state.position)

-- Get the angular coordinates of the simulation direction
local frame = pumas.LocalFrame(position)
local direction = pumas.HorizontalVector{frame = frame}:set(state.direction)

-- Cast the direction to spherical coordinates in the simulation (ECEF) frame
direction = pumas.SphericalVector(direction):transform(nil)
```

!!! note
    The `Coordinates.set` and `Coordinates.transform` methods return a reference
    to `self` even though they operate in-place. This allows to chain them
    conveniently.
    {: .justify}

## See also

[CartesianPoint](coordinates/CartesianPoint.md),
[CartesianVector](coordinates/CartesianVector.md),
[GeodeticPoint](coordinates/GeodeticPoint.md),
[HorizontalVector](coordinates/HorizontalVector.md),
[SphericalPoint](coordinates/SphericalPoint.md),
[SphericalVector](coordinates/SphericalVector.md).
