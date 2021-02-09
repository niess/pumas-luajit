# CompositeMaterials
_A container for mass fractions of a composite material._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*[material]*|`number`| Mass fraction of a base [TabulatedMaterial](TabulatedMaterial) component. |

This metatype behaves as a Lua table of mass fractions indexed by *material*
names but with some restrictions detailed below.
{: .justify}

!!! note
    The table layout cannot be changed. However the mass fraction values can
    be modified. Note that when doing so the physics properties of the
    corresponding [TabulatedMaterial](TabulatedMaterial) are updated
    accordingly, e.g. the composite density.
    {: .justify}

!!! note
    The standard `pairs` function does not work on this metatype. Instead one
    should use the [CompositeMaterials.pairs](#compositematerialspairs) method.
    {: .justify}

### See also

[build](build.md),
[Element](Element.md),
[Material](Material.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).
</div>


<div markdown="1" class="shaded-box fancy">
## CompositeMaterials.pairs

This method behaves as the standard `pairs` function. It returns an iterator
over the base materials names and their corresponding mass fractions.
{: .justify}

### Synopsis
```Lua
CompositeMaterials:pairs()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`function`| Standard `pairs` iterator over the base material names and their corresponding mass fractions. {: .justify} |

</div>
