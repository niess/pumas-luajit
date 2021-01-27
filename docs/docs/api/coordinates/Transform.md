# Transform
_A metatype for representing a linear transform of 3D coordinates._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*translation*|`double [3]`| Translation vector, in m. |
|*rotation*   |`double [3][3]`| Rotation matrix.|
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

### Synopsis

```lua
pumas.Transform(translation, rotation)

pumas.Transform{translation, rotation}

pumas.Transform{transform}
```

!!! note
    In the second form arguments are optional, but for the sake of simplicity
    only the full form is reported. When an argument is missing the
    corresponding attribute is filled with zeros.
    {: .justify}

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*translation*|`double [3]` or `table`| Translation vector, in m. |
|*rotation*   |`double [3][3]` or `table`| Rotation matrix.|
||||
|*transform*|[Transform](Transform.md)| Another [Transform](Transform.md) instance. |


When providing a Lua table as argument its length must be consistent with the
corresponding C type.
{: .justify}

### See also

[LocalFrame](LocalFrame.md).
</div>


<div markdown="1" class="shaded-box fancy">
## Transform.clone

Get a copy (clone) of the transform instance.

---

### Synopsis

```lua
Transform:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[Transform](Transform.md)| Copy of the transform.|

### See also

[Transform.from\_euler](#transformfrom_euler).
</div>


<div markdown="1" class="shaded-box fancy">
## Transform.from\_euler

Set the rotation matrix using Euler angles.

---

### Synopsis

```lua
Transform:from_euler(axis, alpha[, beta, gamma])
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*axis* |`string`| Sequence of rotation axis (see below). |
|*alpha*|`number`| Rotation angle around the 1<sup>st</sup> axis, in radians.|
|*beta* |`number`| Rotation angle around the 2<sup>nd</sup> axis, in radians.|
|*gamma*|`number`| Rotation angle around the 3<sup>rd</sup> axis, in radians.|

The sequence of rotations is encoded in the *axis* argument by specifying the
`'x'`, `'y'` or `'z'` rotation axis according to their order of occurence.
Upper case letters indicate a sequence of extrinsic rotations while lower case
letters are for intrinsic ones. For example, `XZX` indicates proper Euler angles
rotations around the x, z and x-axis.
{: .justify}

### Returns

|Type|Description|
|----|-----------|
|[Transform](Transform.md)| Reference to the updated transform.|

### See also

[Transform.clone](#transformclone).
</div>
