# TopographyLayer
_A metatype for describing a layer of an Earth geometry._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*medium* |[Medium](../Medium.md)                           | Filling medium of the layer. |
|*data*   |[TopographyDataset](../data/TopographyDataset.md)| Top boundary of the layer. |

!!! note
    The layer structure can not be modified after creation. Its properties
    can be modified however, e.g. the medium density of a layer or its
    topography offset. 
    {: .justify}
</div>

<div markdown="1" class="shaded-box fancy">
## Constructor

The [TopographyLayer](TopographyLayer.md) constructor takes two arguments, a
constituting medium and a topography data as illustrated in the synopsis below.
The topography data can be specified by a
[TopographyData](../data/TopographyData.md)([set](../data/TopographyDataset.md))
or by one of its argument.
{: .justify}

### Synopsis

```lua
pumas.TopographyLayer(medium, data)

pumas.TopographyLayer{medium=, data=}
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*medium*|[Medium](../Medium.md) or `string`| Filling medium of the layer. If a `string` is provided it must reference a [TabulatedMaterial](../physics/TabulatedMaterial.md). Then a [UniformMedium](../medium/UniformMedium.md) is implicitly created and filled with the corresponding material. {: .justify}|
|*data*   |`number`, `string`, `table`, [TopographyData](../data/TopographyData.md) or [TopographyDataset](../data/TopographyDataset.md)| Topography data describing the top boundary of the layer. |

---

### See also

[EarthGeometry](EarthGeometry.md),
[InfiniteGeometry](InfiniteGeometry.md),
[PolyhedronGeometry](PolyhedronGeometry.md).

</div>
