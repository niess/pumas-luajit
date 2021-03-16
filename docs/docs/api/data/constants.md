# Constants
_Some physics constants used by PUMAS._

## Content

The [pumas.constants](constants.md) sub-package is a
[Readonly](../others/Readonly.md) table containing the following physics
constants used by PUMAS.

|Name|Description|
|----|-----------|
|`AVOGADRO_NUMBER` | Avogadro number, in $\text{g}/\text{mol}$. |
|`ELECTRON_MASS`   | Electron rest mass, in $\text{GeV}/\text{c}^2$. |
|`MUON_C_TAU`      | Muon decay length, in $\text{m}$. |
|`MUON_MASS`       | Muon rest mass, in $\text{GeV}/\text{c}^2$. |
|`TAU_C_TAU`       | Tau decay length, in $\text{m}$. |
|`TAU_MASS`        | Tau rest mass, in $\text{GeV}/\text{c}^2$. |

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
