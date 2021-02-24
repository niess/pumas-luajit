# UnitaryTransformation
_A metatype for representing a unitary transformation of 3D coordinates._


<div markdown="1" class="shaded-box fancy">
## Attributes

A [UnitaryTransformation](UnitaryTransformation.md) object represents an affine
transformation of space coordinates composed of a translation, $\vec{t}$, and of
a unitary linear transformation, $U$, e.g. a rotation. It changes the space
coordinates $\vec{r}$ to $\vec{r}'$ as:
{: .justify}

$$ \vec{r}' = U \vec{r} + \vec{t} $$

The [UnitaryTransformation](UnitaryTransformation.md) preserves angles and
distances. It has the following attributes:
{: .justify}

|Name|Type|Description|
|----|----|-----------|
|*translation*|`double [3]`   | Translation vector, $\vec{t}$, in m. |
|*matrix*     |`double [3][3]`| Unitary matrix, $U$, representing the linear transformation, e.g. a rotation. {: .justify}|
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The [UnitaryTransformation](UnitaryTransformation.md) constructor has 3 forms as
detailed in the synopsis below.

### Synopsis

```lua
pumas.UnitaryTransformation(translation, matrix)

pumas.UnitaryTransformation{translation=, matrix=}

pumas.UnitaryTransformation(transformation)
```

!!! note
    In the second form arguments are optional, but for the sake of simplicity
    only the full form is reported. When an argument is missing the
    corresponding attribute is filled with zeros.
    {: .justify}

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*translation*   |`double [3]` or `table`                          | Translation vector, $\vec{t}$, in m. |
|*matrix*        |`double [3][3]` or `table`                       | Unitary matrix, $U$, representing the linear transform, e.g. a rotation. {: .justify}|
||||
|*transformation*|[UnitaryTransformation](UnitaryTransformation.md)| Another [UnitaryTransformation](UnitaryTransformation.md) instance. |

!!! note
    When providing a Lua table as argument its length must be consistent with
    the corresponding C type.
    {: .justify}

!!! warning
    The provided matrix must be unitary, e.g. representing a rotation or a
    reflection.
    {: .justify}

### See also

[LocalFrame](LocalFrame.md).
</div>


<div markdown="1" class="shaded-box fancy">
## UnitaryTransformation.clone

Get a copy (clone) of the transformation instance.

---

### Synopsis

```lua
UnitaryTransformation:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[UnitaryTransformation](UnitaryTransformation.md)| Copy of the transformation.|

### See also

[from\_euler](#unitarytransformationfrom_euler).
</div>


<div markdown="1" class="shaded-box fancy">
## UnitaryTransformation.from\_euler

Set the matrix of the linear transformation to a rotation defined by
[Euler angles](https://en.wikipedia.org/wiki/Euler_angles).

---

### Synopsis

```lua
UnitaryTransformation:from_euler(axis, alpha[, beta, gamma])
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
|[UnitaryTransformation](UnitaryTransformation.md)| Reference to the updated transformation.|

### See also

[clone](#unitarytransformationclone).
</div>
