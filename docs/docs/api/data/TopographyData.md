# TopographyData
_A metatype for wrapping topography data._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*path*  |`string`| Path to the topography data or `nil` for a geoid.|
|*offset*|`number`| Global offset applied to the topography data.|

!!! note
    The data *offset* can be modified but not the *path* attribute. One can also
    directly add or subtract a `number` offset to the
    [TopographyData](TopographyData.md) table. Note that the result of this
    operation is a shallow clone of the initial data as returned by
    [TopographyData.clone](#topographydataclone).
    {: .justify }
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The [TopographyData](TopographyData.md) constructor takes zero to two arguments
as shown in the synospis below. If no argument is provided a flat topography
with zero elevation is assumed, i.e. a geoid. If a path is provided as first
argument then it must refer to a topography data format supported by the
[TURTLE](https://github.com/niess/turtle) library: ASC, GEOTIFF, GRD, HGT or
PNG. Global model with multiple data tiles are also supported, e.g.
[SRTMGL1](https://lpdaac.usgs.gov/products/srtmgl1v003/). or
[ASTER-GDEM2](https://asterweb.jpl.nasa.gov/gdem.asp). In the latter case,
*path* points to a directory containing the topography tiles. In addition, the
topography data can be shifted by a global *offset* provided as an extra
argument.
{: .justify }


### Synopsis
```Lua
pumas.TopographyData((offset))

pumas.TopographyData(path, (offset))
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*path*    |`string`| Path to a topography file or to folder containing topography tiles.|
|(*offset*)|`number`| Global offset applied to the topography data. Defaults to 0 if not provided.|


### Returns

|Type|Description|
|----|-----------|
|`table`| A Lua table of metatype [TopographyData](TopographyData.md).|

### See also

[constants](constants.md),
[elements](elements.md),
[materials](materials.md),
[TopographyDataset](TopographyDataset.md).
</div>


<div markdown="1" class="shaded-box fancy">
## TopographyData.clone

Get a shallow copy of the [TopographyData](TopographyData.md). The cloned
object refers to the same data but with an independent offset. In order to
get a deep copy of the data one should instead create a new instance with the
[constructor](#constructor).
{: .justify}

### Synopsis
```Lua
TopographyData:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[TopographyData](TopographyData.md)| Shallow copy of the topography data.|


### See also

[TopographyData.elevation](#topographydataelevation)
</div>


<div markdown="1" class="shaded-box fancy">
## TopographyData.elevation

Get the topography elevation at an Earth location. The input location can be
specified by providing its latitude and longitude or by providing a point
instance (e.g.  [GeodeticPoint](../coordinates/GeodeticPoint.md),
[CartesianPoint](../coordinates/CartesianPoint.md)), as detailed in the synopsis
below.
{: .justify}

### Synopsis
```Lua
TopographyData:elevation(coordinates)

TopographyData:elevation(latitude, longitude)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*coordinates* |[Coordinates](../coordinates/Coordinates.md)| Point coordinates, in m.|
||||
|*latitude* |`number`| Latitude, in deg.|
|*longitude*|`number`| Longitude, in deg.|


### Returns

|Type|Description|
|----|-----------|
|`number` or `nil`| Topography elevation, in m, or `nil` if there are no data for the requested location.|

!!! note
    Topography data are usually provided w.r.t. the sea level. In order to get
    the altitude w.r.t. the WGS84 ellipsoid (e.g. the GPS altitude) one needs
    to correct from the geoid undulations.
    {: .justify}

### See also

[TopographyData.clone](#topographydataclone)
</div>
