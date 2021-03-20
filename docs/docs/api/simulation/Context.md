# Context
_Monte Carlo simulation context._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*geometry*    |[Geometry](../Geometry.md)      | Geometry of the simulation. |
|*limit*       |[Limit](Limit.md)               | External limits for the transport, e.g. on the kinetic energy or the particle range. {: .justify} |
|*mode*        |[Mode](Mode.md)                 | Configuration flags for the simulation. |
|*physics*     |[Physics](../physics/Physics.md)| Physics tabulations used by this context (cannot be modified). |
|*random\_seed*|`number`                        | Random seed of the pseudo random numbers generator used by this simulation flow. {: .justify} |
|*recorder*    |[Recorder](Recorder.md)         | User supplied recorder (callback) for Monte Carlo steps. |

!!! note
    All attributes can be modified (set) appart from the *physics*. See the
    [constructor](#constructor) for valid argument types and automatic inference
    rules when setting an attribute.
    {: .justify}

</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The Monte Carlo [Context](Context.md) is the main interface to a simulation
flow. Its constructor has two forms as shown in the synopsis below. Both forms
require a [Physics](../physics/Physics.md) instance to be provided. The first
form accepts an optionnal [Mode](Mode.md) configuration flag as second argument.
The second form takes a single table argument with fields corresponding to the
simulation context [attributes](#attributes).
{: .justify}

!!! note
    The [Physics](../physics/Physics.md) of the simulation context is defined at
    creation and cannot be modified afterwards apart from the mass fractions
    of composite materials. A new simulation context must be created instead.
    {: .justify}

### Synopsis

```lua
pumas.Context(physics, (mode))

pumas.Context{
    physics=, (geometry)=, (limit)=, (mode)=, (random_seed)=, (recorder)=}
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*physics*       |`string` or [Physics](../physics/Physics.md)| Physics tabulations used by this context (cannot be modified afterwards). If a `string` argument is provided it must point to a dump of tabulations, e.g. generated with the [build](../physics/build.md) function. Then a new [Physics](../physics/Physics.md) instance is automatically created from these tables. {: .justify} |
|||
|(*geometry*)    |`string` or [Geometry](../Geometry.md)      | Geometry of the simulation. If a `string` argument is provided it must reference a [TabulatedMaterial](../physics/TabulatedMaterial.md) of the *physics*. Then, an [InfiniteGeometry](../geometry/InfiniteGeometry.md) is automatically created and filled with a [UniformMedium](../medium/UniformMedium.md) using the corresponding material. {: .justify} |
|(*limit*)       |`table`                                        | External limits for the transport, e.g. on the kinetic energy or the particle range. The `table` keys must refer to [Limit](Limit.md) attributes, e.g. as `{distance = 1000}` for a 1 km limit on the travelled distance. By default no external limit is set. {: .justify} |
|(*mode*)        |`string`                 | Configuration flags for the simulation. The `string` must indicate [Mode](Mode.md) attributes flag(s) with proper separator(s) (whitespace, comma, etc.). Default value is `detailed forward`. {: .justify} |
|(*random\_seed*)|`number`                                    | Random seed of the pseudo random numbers generator used by this simulation flow. If not provided then the random seed is initialised from the host, e.g. using `/dev/urandom` on Unix. {: .justify} |
|(*recorder*)    |`function` or [Recorder](Recorder.md)       | User supplied recorder (callback) for Monte Carlo steps. If a `function` argument is provided then it is autmatically wrapped with a [Recorder](Recorder.md) instance with a *period* of 1. {: .justify} |

### See also

[Event](Event.md),
[Limit](Limit.md),
[Mode](Mode.md),
[Recorder](Recorder.md),
[State](State.md).
</div>


<div markdown="1" class="shaded-box fancy">
## Context.medium

Get the medium corresponding to a given point [Coordinates](../Coordinates.md)
or for a at a given Monte Carlo [State](State.md) position for the
current [Geometry](../Geometry.md).
{: .justify}

---

### Synopsis

```lua
Context:medium(coordinates)

Context:medium(state)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*coordinates*|[Coordinates](../Coordinates.md)| Point coordinates at which to query the geometry. {: .justify}|
||||
|*state*|[State](State.md)| State (position) for which to query the geometry. {: .justify}|

### Returns

|Type|Description|
|----|-----------|
|[Medium](../Medium.md)| Geometry medium correpsonding to the provided Monte Carlo state. {: .justify}|

!!! note
    If no geometry is defined or if the requested position is located outside of
    the current geometry then `nil` is returned. {: .justify}

### See also

[random](#contextrandom),
[transport](#contexttransport).
</div>


<div markdown="1" class="shaded-box fancy">
## Context.random

Get onr or more pseudo random number(s) from a uniform distribution over
$[0,1]$. A [Mersenne Twister](https://en.wikipedia.org/wiki/Mersenne_Twister)
algorithm is used.

---

### Synopsis

```lua
Context:random()

Context:random(n)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*n*|`number`| Number of pseudo-random numbers to generate. Defaults to 1. {: .justify}|

### Returns

|Type|Description|
|----|-----------|
|`number`| First pseudo random number in $[0, 1]$.|
| &vellip; {: .center} | &vellip; {: .center} |
|`number`| Last (n<sup>th</sup>) pseudo random number in $[0, 1]$.|

!!! note
    This method returns one or more pseudo-random number as requested with
    the *n* argument.
    {: .justify}

### See also

[medium](#contextmedium),
[transport](#contexttransport).
</div>


<div markdown="1" class="shaded-box fancy">
## Context.transport

Transport a Monte Carlo [State](State.md) using the current geometry and
simulation settings.
{: .justify}

---

### Synopsis

```lua
Context:transport(state)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*state*|[State](State.md)| Initial Monte Carlo state to transport.|

!!! warning
    The provided Monte Carlo state is modified in-place, i.e. at return it
    contains the final step Monte Carlo data. If initial data are to be retained
    then the provided *state* might be cloned before the transport.
    {: .justify}

### Returns

|Type|Description|
|----|-----------|
|[Event](Event.md)| The end step Monte Carlo event. {: .justify} |
|`table`          | Size 2 table containing the initial and final [Medium](../Medium.md) of the transport. {: .justify} |

### See also

[medium](#contextmedium),
[random](#contextrandom).
</div>
