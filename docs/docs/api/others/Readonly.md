# Readonly
_A readonly Lua table._


<div markdown="1" class="shaded-box fancy">
## Description

The [Readonly](Readonly.md) metatype represent a standard Lua table but with a
protected content. It wraps a native table in order to make it readonly.  The
wrapped table can still be indexed as a usual table. However iterating requires
to use the [Readonly.pairs](#readonlypairs) and
[Readonly.ipairs](#readonlyipairs) methods instead of the standard `pairs` and
`ipairs` functions.
{: .justify}

!!! note
    The [Readonly](Readonly.md) metatype is used in the `pumas` package in order
    to indicate data that should not be modified by users. This metatype is not
    meant to be directly instanciated by end-users.
    {: .justify}

### See also

[version](version.md).
</div>


<div markdown="1" class="shaded-box fancy">
## Readonly.ipairs

This method behaves as the standard `ipairs` function. It returns an iterator
over the elements of the native table.
{: .justify}

### Synopsis
```Lua
Readonly:ipairs()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`function`| Standard `ipairs` iterator over the native table. {: .justify} |

### See also

[pairs](#readonlypairs).
</div>


<div markdown="1" class="shaded-box fancy">
## Readonly.pairs

This method behaves as the standard `pairs` function. It returns an iterator
over the elements of the native table.
{: .justify}

### Synopsis
```Lua
Readonly:pairs()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|`function`| Standard `pairs` iterator over the native table. {: .justify} |

### See also

[ipairs](#readonlyipairs).
</div>
