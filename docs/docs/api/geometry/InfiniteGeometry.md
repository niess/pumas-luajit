# InfiniteGeometry
_A metatype for representing a geometry of infinite extension._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*medium*|[Medium](../physics/Medium.md)| The constitutive medium. |
</div>

<div markdown="1" class="shaded-box fancy">
## Constructor

The [InfiniteGeometry](InfiniteGeometry.md) wraps a simulation
[Medium](../physics/Medium.md). It takes a single mandatory argument: the
medium.

### Synopsis

```lua
pumas.InfiniteGeometry(medium)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*medium*|[Medium](../physics/Medium.md)| The constitutive medium. |

---

### See also

[EarthGeometry](EarthGeometry.md),
[PolytopeGeometry](PolytopeGeometry.md),
[TopographyLayer](TopographyLayer.md),

</div>


<div markdown="1" class="shaded-box fancy">
## InfiniteGeometry.insert

Insert a daughter geometry into the [InfiniteGeometry](InfiniteGeometry.md).
This method behaves as the `table.insert` Lua function. If no index is specified
the daughter geometry is appended as the last element.
{: .justify}

---

### Synopsis

```lua
InfiniteGeometry:insert(daughter)

InfiniteGeometry:insert(index, daughter)
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*index*|`number`|Table index of the inserted geometry.|
|*daughter*|[Geometry](Geometry.md)|Daughter geometry to insert.|

---

### Returns

`nil`

---

### See also

[InfiniteGeometry.remove](#infinitegeometryremove).
</div>


<div markdown="1" class="shaded-box fancy">
## InfiniteGeometry.remove

Remove a daughter geometry from the [InfiniteGeometry](InfiniteGeometry.md)
given its index. If no index is provided the last daughter geometry is removed.
This method behaves as the `table.remove` Lua function.
{: .justify}

---

### Synopsis

```lua
InfiniteGeometry:remove([index])
```

---

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*index*|`number`|Table index of the daughter geometry to remove.|

---

### Returns

|Type|Description|
|----|-----------|
|[Geometry](Geometry.md)| The removed geometry.|

---

### See also

[InfiniteGeometry.insert](#infinitegeometryinsert).

</div>
