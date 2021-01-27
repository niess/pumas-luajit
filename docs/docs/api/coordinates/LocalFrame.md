# LocalFrame
_Coordinates transform representing a local Earth frame._

The [LocalFrame](LocalFrame.md) constructor creates a [Transform](Transform.md)
representing a local Earth frame.
{: .justify}

## Synopsis
``` lua
pumas.LocalFrame(origin)
```

## Arguments

|Name|Type|Description|
|----|----|-----------|
|*origin* |`Coordinates`| Origin of the local Earth frame.|


## Returns

|Type|Description|
|----|-----------|
|[Transform](Transform.md)| Transform representing the local Earth frame.|

## Examples

``` lua
local origin = pumas.GeodeticPoint(latitude, longitude, altitude)
local frame = pumas.LocalFrame(origin)
```

## See also

[Transform](Transform.md)
