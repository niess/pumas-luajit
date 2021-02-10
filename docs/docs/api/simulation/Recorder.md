# Recorder
_A metatype for recording Monte Carlo steps._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*period*|`number`  | Recording period. If set to `1` all Monte carlo steps are recorded. Otherwise a downsampling by a factor of *period* is applied. {: .justify} |
|*record*|`function`| Callback function applied to Monte Carlo steps. |

The *record* callback function has the following synopsis and arguments. No
return value is expected.
{: .justify}

```lua
Recorder.record(state, medium, event)
```

|Name|Type|Description|
|----|----|-----------|
|*state* |[State](State.md)     | Recorded Monte Carlo state. |
|*medium*|[Medium](../Medium.md)| Medium at the Monte Carlo state location. |
|*event* |[Event](Event.md)     | Event flag of the Monte Carlo step. |

!!! warning
    The *event* and *state* arguments are overwritten between successive calls
    of the *record* callback function.  They must be copied (e.g. using the
    *clone* method) if data are to be retained.
    {: .justify}

</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The [Recorder](Recorder.md) constructor takes two optionnal arguments as
shown in the synopsis below. If no callback function is provided a default one
is used resulting in Monte Carlo steps to be printed to the standard output.
{: .justify}

### Synopsis

```lua
pumas.Recorder((record), (period))
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|(*record*)|`function`| User callback as detailed above. |
|(*period*)|`number`  | Recording period (downsampling). Defaults to `1`, i.e. the *record* callback is called for all Monte Carlo steps. {: .justify} |

### See also

[Context](Context.md),
[Event](Event.md),
[Mode](Mode.md),
[State](State.md).
</div>
