# TopographyDataset
_A metatype for an ordered set of topography data._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*[i]*  |[TopographyData](TopographyData.md)| The *i<sup>th</sup>* data member of the set.|

!!! note
    The structure of the set cannot be modified. The properties of its members
    are mutable however, e.g. their offset. The set also supports addition and
    subtraction operations with a `number` resultint resulting in all its data
    members being offset.
    {: .justify }
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

A [TopographyDataset](TopographyDataset.md) represents an union of various data
referering to a same topography. It behaves as a
[TopographyData](TopographyData.md) but considering the *best* data available in
its set.  The constructor takes a table of *data* as argument or a variable
number of *data* arguments. Each *data* element can be either a
[TopographyData](TopographyData.md) object or one of its
[constructor](TopographyData.md#constructor) arguments, i.e. a *path* `string`
or an *offset* `number` for a geoid. The order in which the *data* elements are
specified in the constructor does matter. Elements defined first have
precedence, e.g.  when requesting the topography elevation.
{: .justify }

!!! note
    When providing a [TopographyData](TopographyData.md) argument a shallow copy
    is done. The set instance refers to the same input data but with an
    independent offset.
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
## TopographyDataset.clone

Get a shallow copy of the [TopographyDataset](TopographyDataset.md). The cloned
data members to the same data than in the initial set but with independent
offsets. In order to get a deep copy of the data one should instead create a
new instance with the [constructor](#constructor).
{: .justify}

### Synopsis
```Lua
TopographyDataset:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[TopographyDataset](TopographyDataset.md)| Shallow copy of the topography dataset.|

### See also

[TopographyDataset.elevation](topographydatasetelevation),
[TopographyDataset.ipairs](topographydatasetipairs).
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
|`number` or `nil`| Topography elevation, in m, or `nil` if there are no data in the set for the requested location.|

!!! note
    Topography data are usually provided w.r.t. the sea level. In order to get
    the altitude w.r.t. the WGS84 ellipsoid (e.g. the GPS altitude) one needs
    to correct from the geoid undulations.
    {: .justify}

### See also

[TopographyDataset.clone](topographydatasetclone),
[TopographyDataset.ipairs](topographydatasetipairs).
</div>


<div markdown="1" class="shaded-box fancy">
## TopographyDataset.ipairs

Stateless iterator over the set data members. This method behaves as the
`ipairs` Lua function.
{: .justify}

### Synopsis
```Lua
TopographyDataset:ipairs()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`function`| Stateless iterator over the set data members.|

### See also

[TopographyDataset.clone](topographydatasetclone),
[TopographyDataset.elevation](topographydatasetelevation).

</div>
