# Constants
_Some physics constants used by PUMAS._

## Content

The [constants](constants.md) Lua table contains the following `string`,
`number` pairs.

|Name|Description|
|----|-----------|
|`AVOGADRO_NUMBER` | Avogadro number, in g/mol |
|`ELECTRON_MASS`   | Electron rest mass, in GeV/C<sup>2</sup> |
|`MUON_C_TAU`      | Muon decay length, in GeV/C<sup>2</sup> |
|`MUON_MASS`       | Muon rest mass, in GeV/C<sup>2</sup> |
|`TAU_C_TAU`       | Tau decay length, in GeV/C<sup>2</sup> |
|`TAU_MASS`        | Tau rest mass, in GeV/C<sup>2</sup> |

## Examples

``` lua
-- Get the electron rest mass
local me = pumas.constants.ELECTRON_MASS
```

## See also

[elements](elements.md),
[materials](materials.md),
[TopographyData](TopographyData.md),
[TopographyDataset](TopographyDataset.md).
