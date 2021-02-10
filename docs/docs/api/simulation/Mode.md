# Mode
_Configuration flags for a Monte Carlo simulation context._


## Attributes

|Name|Type|Description|
|----|----|-----------|
|*direction*  |`string` | Direction of the simulation flow. One of `'forward'` or `'backward'`. {: .justify} |
|*energy_loss*|`string` | Algorithm for energy losses. One of `'csda'`, `'detailed'`, `'hybrid'` or `'virtual'`. {: .justify} |
|*scattering* |`string` | Algorithm for the scattering. One of `'full_space'` or `'longitudinal'`. {: .justify} |
|*decay*      |`string` | Algorithm for decays. One of `'decay'`, `'stable'` or `'weight'`. {: .justify} |

!!! note
    This metatable has no proper constructor. It is instanciated when creating
    a new simulation [Context](Context.md) and linked to the latter. Attributes
    can be modified in order to configure the simulation context.
    {: .justify}

## See also

[Context](Context.md),
[Event](Event.md),
[Limit](Limit.md),
[Recorder](Recorder.md).
[State](State.md).
</div>
