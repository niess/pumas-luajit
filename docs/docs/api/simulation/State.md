# State
_A container for the state of Monte Carlo particles._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*charge*   |`number`    | Electric charge, i.e. `1` or `-1`. |
|*kinetic*  |`number`    | Kinetic energy, in GeV. |
|*position* |`double [3]`| Cartesian coordinates of the position in the simulation frame, in m. {: .justify} |
|*direction*|`double [3]`| Cartesian coordinates of the momentum direction in the simulation frame. {: .justify} |
|||
|*distance* |`number`    | Travelled distance, in m. |
|*grammage* |`number`    | Travelled grammage distance, in kg/m<sup>2</sup>. |
|*time*     |`number`    | Spent proper time, in m/c. |
|*weight*   |`number`    | Monte Carlo weight. |
|||
|*decayed*  |`boolean`   | Flag indicating if the particle has decayed (`true`) or not (`false`). {: .justify} |
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The Monte Carlo [State](State.md) constructors has three forms as indicated in
the synopsis below. The first form takes no argument and returns an blank state
with all atributes equal to zero. The second form is a copy constructor for
another [State](State.md). The third form allows to specify attribute values and
provide defaults if not specified.
{: .justify}

### Synopsis

```lua
pumas.State()

pumas.State(state)

pumas.State{(charge)=, (kinetic)=, (position)=, (direction)=, (distance)=,
    (grammage)=, (time)=, (weight)=, (decayed)=}
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*state*|[State](State.md)| Another [State](State.md) instance to copy. |
|||
|(*charge*)   |`number`                        | Electric charge, i.e. `1` or `-1`. Defaults to `-1`. {: .justify} |
|(*kinetic*)  |`number`                        | Initial kinetic energy, in GeV. Defaults to `1` GeV. {: .justify} |
|(*position*) |[Coordinates](../Coordinates.md)| Initial position, in m. Defaults to the origin of the simulation frame. {: .justify} |
|(*direction*)|[Coordinates](../Coordinates.md)| Initial momentum direction. Defaults to the vertical of the simulation frame. {: .justify} |
|||
|(*distance*) |`number`    | Initial travelled distance, in m. Defaults to `0` m. {: .justify} |
|(*grammage*) |`number`    | Initial ravelled grammage, in kg/m<sup>2</sup>. Defaults to `0` kg/m<sup>2</sup>. {: .justify} |
|(*time*)     |`number`    | Initial proper time, in m/c. Defaults to `0` m/c. {: .justify} |
|(*weight*)   |`number`    | Initial Monte Carlo weight. Defaults to `0`. {: .justify} |
|||
|(*decayed*)  |`boolean`   | Flag indicating if the particle has decayed (`true`) or not (`false`). {: .justify} |

!!! warning
    Default argument values are only set when using the third form of the
    constructor, i.e. when providing a table argument. When no argument is
    provided a blank state is returned with all attributes equal to zero.
    {: .justify}

### See also

[Context](Context.md),
[Event](Event.md),
[Mode](Mode.md),
[Recorder](Recorder.md).
</div>


<div markdown="1" class="shaded-box fancy">
## State.clear

Clear the Monte Carlo state reseting all its attributes to zero.
{: .justify}

---

### Synopsis

```lua
State:clear()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[State](State.md)| Reference to the updated Monte Carlo state.|

### See also

[State.clone](#stateclone),
[State.set](#stateset).
</div>


<div markdown="1" class="shaded-box fancy">
## State.clone

Get a copy (clone) of the [State](State.md) instance.

---

### Synopsis

```lua
State:clone()
```

### Arguments

None, except *self*.

### Returns

|Type|Description|
|----|-----------|
|[State](State.md)| Copy of the Monte Carlo state.|

### See also

[State.clear](#stateclear),
[State.set](#stateset).
</div>


<div markdown="1" class="shaded-box fancy">
## State.set

Set the Monte Carlo state from another [State](State.md) instance.
{: .justify}

---

### Synopsis

```lua
State:set(state)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*state*|[State](State.md)| Monte Carlo state to copy.|

### Returns

|Type|Description|
|----|-----------|
|[State](State.md)| Reference to the updated Monte Carlo state.|

### See also

[State.clear](#stateclear),
[State.clone](#stateclone).
</div>
