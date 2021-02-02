# TopographyDataset
_A metatype for an ordered set of topography data._


## Attributes

|Name|Type|Description|
|----|----|-----------|
|*[i]*  |`number`| The *i<sup>th</sup>* data member of the collection.|

!!! note
    This metatype is equivalent to a Lua table of
    [TopographyData](TopographyData.md) instances indexed by numbers.  One can
    directly add or subtract an offset number to the
    [TopographyDataset](TopographyDataset.md) table resulting in all its data
    members being offset.
    {: .justify }
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The [TopographyDataset](TopographyDataset.md) constructor takes a table of
*data* as argument or a variable number of *data* arguments. Each *data* element
can be either a [TopographyData](TopographyData.md) object or one of its
constructor arguments, i.e. a *path* `string` or an *offset* `number` for a
geoid.
{: .justify }

!!! note
    A [TopographyDataset](TopographyDataset.md) represents an union of various
    data referering to a same topography. It behaves as a
    [TopographyData](TopographyData.md) but considering the *best* data
    available in its set. The order in which the *data* elements are specified
    in the constructor does matter. Elements defined first have precedence, e.g.
    when requesting the topography elevation.
    {: .justify }

### Synopsis
```Lua
pumas.TopographyDataset{data[, ...]}

pumas.TopographyDataset(data[, ...])
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*data*|`number`, `string` or [TopographyData](TopographyData.md)| [TopographyData](TopographyData.md) or any argument refering to them as defined in the [TopographyData constructor](TopographyData.md#constructor).|


### Returns

|Type|Description|
|----|-----------|
|`table`| A Lua table of metatype [TopographyDataset](TopographyDataset.md).|

### See also

[constants](constants.md),
[elements](elements.md),
[materials](materials.md),
[TopographyData](TopographyData.md).
</div>


<div markdown="1" class="shaded-box fancy">
## TopographyDataset.elevation

Get the topography elevation at an Earth location using the first matching data
of the set. The input location can be specified by providing its latitude and
longitude or by providing a point instance (e.g.
[GeodeticPoint](../coordinates/GeodeticPoint.md),
[CartesianPoint](../coordinates/CartesianPoint.md)), as detailed in the synopsis
below.
{: .justify}

### Synopsis
```Lua
TopographyDataset:elevation(coordinates)

TopographyDataset:elevation(latitude, longitude)
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
</div>
