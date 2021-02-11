# State
_Event flags for the Monte Carlo simulation._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*none*                  |`boolean`| No event. |
|*start*                 |`boolean`| Start of a Monte Carlo transport. |
|*medium*                |`boolean`| A change of medium. |
|*weight*                |`boolean`| Null or negative Monte Carlo weight. |
|*stop*                  |`boolean`| Stop of Monte Carlo transport. |
|*limit*                 |`boolean`| Any external limit: distance, grammage, kinetic energy or time. {: .justify} |
|*vertex*                |`boolean`| Any interaction (desintegration) vertex. |
|||
|*vertex\_coulomb*       |`boolean`| A Coulomb interaction vertex. |
|*vertex\_decay*         |`boolean`| A decay vertex. |
|*vertex\_del*           |`boolean`| Any discrete energy loss (DEL): Bremsstrahlung, delta ray, $e^+e^-$ pair creation or photonuclear event. {: .justify} |
|||
|*vertex\_bremsstrahlung*|`boolean`| A Bremsstrahlung DEL vertex. |
|*vertex\_delta\_ray*    |`boolean`| A delta ray DEL vertex. |
|*vertex\_pair\_creation*|`boolean`| An $e^+e^-$ pair creation DEL vertex. |
|*vertex\_photonuclear*  |`boolean`| A photonuclear DEL vertex. |
|||
|*limit\_distance*       |`boolean`| A travelled distance external limit. |
|*limit\_grammage*       |`boolean`| A travelled grammage external limit. |
|*limit\_kinetic*        |`boolean`| A kinetic energy external limt. |
|*limit\_time*           |`boolean`| A proper time external limit. |

!!! note
    When getting the status of a multi-cases event, e.g. *limit*, `true` is
    returned if any case is true, otherwise `false` is returned, i.e. if all
    cases are false. But when setting a multi case event all cases are set to
    `true` or `false`.
    {: .justify}
</div>

<div markdown="1" class="shaded-box fancy">
## Constructor

The Monte Carlo [Event](Event.md) constructor has two forms as illustrated in
the synopsis below. The first form is a copy constructor from another
[Event](Event.md) instance. The second form takes an arbitrary number of event
flags as argument. Event flags must correspond to the attributes [listed
above](#attributes). Any provided flag is initialized to `true`. By default a
*none* event is returned, i.e. all other flags are `false`.
{: .justify}

### Synopsis

```lua
pumas.Event(event)

pumas.Event(flag, ...)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*event*|[Event](Event.md)|Another event instance to copy.|
|||
|*flag*|`string`| The argument must reference a flag defined as [attribute](#attributes), e.g. `'medium'`, `'vertex'`, etc. The corresponding flag is set to `true`. {: .justify} |


### See also

[Context](Context.md),
[Mode](Mode.md),
[Recorder](Recorder.md),
[State](State.md).
</div>


<div markdown="1" class="shaded-box fancy">
## Event.clear

Clear the Monte Carlo event reseting all its flags to zero, i.e. to the *none*
event.
{: .justify}

---

### Synopsis

```lua
Event:clear()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[Event](Event.md)| Reference to the updated Monte Carlo event.|

### See also

[clone](#eventclone).
</div>


<div markdown="1" class="shaded-box fancy">
## Event.clone

Get a copy (clone) of the [Event](Event.md) instance.

---

### Synopsis

```lua
Event:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[Event](Event.md)| Copy of the Monte Carlo event.|

### See also

[clear](#eventclear).
</div>
