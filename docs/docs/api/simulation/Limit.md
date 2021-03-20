# Limit
_User limits for a Monte Carlo simulation context._


## Attributes

|Name|Type|Description|
|----|----|-----------|
|*distance*|`number` or `nil`| Limit on the travelled distance, in m. Defaults to `nil` i.e. no limit. {: .justify} |
|*grammage*|`number` or `nil`| Limit on the travelled grammage in kg/m<sup>2</sup>. Defaults to `nil` i.e. no limit. {: .justify} |
|*energy*  |`number` or `nil`| Limit on the kinetic energy, in GeV. In *forward* this sets a upper limit but in *backward* it sets a lower limit. Defaults to `nil` i.e. no limit. {: .justify} |
|*time*    |`number` or `nil`| Limit on the proper time, in m/c. Defaults to `nil` i.e. no limit. {: .justify} |

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
