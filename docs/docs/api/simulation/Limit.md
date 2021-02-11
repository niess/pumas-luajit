# Limit
_External limits for a Monte Carlo simulation context._


## Attributes

|Name|Type|Description|
|----|----|-----------|
|*distance*|`number`| Limit on the travelled distance, in m. {: .justify} |
|*grammage*|`number`| Limit on the travelled grammage in kg/m<sup>2</sup>. {: .justify} |
|*energy*  |`number`| Limit on the kinetic energy, in GeV. In *forward* this sets a upper limit but in *backward* it sets a lower limit. {: .justify} |
|*time*    |`number`| Limit on the proper time, in m/c. {: .justify} |

!!! note
    This metatable has no proper constructor. It is instanciated when creating
    a new simulation [Context](Context.md) and linked to the latter. Attributes
    can be modified in order to configure the simulation context.
    {: .justify}

## See also

[Context](Context.md),
[Event](Event.md),
[Mode](Mode.md),
[Recorder](Recorder.md).
[State](State.md).
</div>
