# EarthGeometry
_A metatype for representing an Earth geometry as stacked topography layers._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*date*             |`string` or `nil`                                   | Date (time) of the simulation encoded as a `'dd/mm/yy'` string. |
|*geoid_undulations*|[TopographyData](../data/TopographyData.md) or `nil`| Map of geoid undulations w.r.t. the WGS84 ellipsoid.|
|*layers*           |[Readonly](../others/Readonly.lua)                  | Table containing the [TopographyLayer](TopographyLayer.md)s indexed by number. Note that the 1<sup>st</sup> layer is on top. |
|*magnet*           |`boolean`, `string` or `nil`                        | Flag for switching the default geomagnetic field ([IGRF13](https://www.ngdc.noaa.gov/IAGA/vmod/igrf.html)) or path to an alternative model specified as a COF file.|

!!! note
    The *layers* structure can not be modified after creation. The properties of
    a layer can be modified however, e.g. the medium density of a layer or its
    topography offset. The other attributes: *date*, *geoid_undulations* and
    *magnet* can be modified as specified in the constructor below.
    {: .justify}
</div>

<div markdown="1" class="shaded-box fancy">
## Constructor

The [EarthGeometry](EarthGeometry.md) constructor accepts an arbitrary number of
[TopographyLayer](TopographyLayer.md)s to be provided. Note that the order of
these arguments matters. Layers provided first are above others. Extra options
can also be set as keyword arguments, e.g. the geomagnetic field at a given
date or geoid undulations.

### Synopsis

```lua
pumas.EarthGeometry(layer, ...)

pumas.EarthGeometry{layer, ..., (date)=, (geoid_undulations)=, (magnet)=}
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*layer*              |`table` or [TopographyLayer](TopographyLayer.lua)| [TopographyLayer](TopographyLayer.md) or a table argument consistent with the constructor of the latter, e.g. `{medium, data}`. |
|*(date)*             |`number` or `string`                             | Date (time) of the simulation encoded as a number since the epoch or as a `'dd/mm/yy'` string. |
|*(geoid_undulations)*|[TopographyData](../data/TopographyData.md)      | Map of geoid undulations w.r.t. the WGS84 ellipsoid.|
|*(magnet)*           |`boolean` or `string`                            | Flag for switching the default geomagnetic field ([IGRF13](https://www.ngdc.noaa.gov/IAGA/vmod/igrf.html)) or path to an alternative model sepcified as a COF file.|

---

### See also

[InfiniteGeometry](InfiniteGeometry.md),
[PolyhedronGeometry](PolyhedronGeometry.md),
[TopographyLayer](TopographyLayer.md),

</div>


<div markdown="1" class="shaded-box fancy">
## EarthGeometry.insert

Insert a daughter geometry into the [EarthGeometry](EarthGeometry.md). This
method behaves as the `table.insert` Lua function. If no index is specified
the daughter geometry is appended as the last element.
{: .justify}

---

### Synopsis

```lua
EarthGeometry:insert(daughter)

EarthGeometry:insert(index, daughter)
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*index*|`number`|Table index of the inserted geometry.|
|*daughter*|[Geometry](../Geometry.md)|Daughter geometry to insert.|

---

### Returns

`nil`

---

### See also

[remove](#earthgeometryremove).
</div>


<div markdown="1" class="shaded-box fancy">
## EarthGeometry.remove

Remove a daughter geometry from the [EarthGeometry](EarthGeometry.md) given its
index. If no index is provided the last daughter geometry is removed. This
method behaves as the `table.remove` Lua function.
{: .justify}

---

### Synopsis

```lua
EarthGeometry:remove((index))
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|(*index*)|`number`|Table index of the daughter geometry to remove.|

---

### Returns

|Type|Description|
|----|-----------|
|[Geometry](../Geometry.md)| The removed geometry.|

---

### See also

[insert](#earthgeometryinsert).

</div>
