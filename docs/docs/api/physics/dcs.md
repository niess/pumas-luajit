# DCS
_Differential cross-sections for radiative processes._

## Content

The [dcs](dcs.md) table provides an interface to the differential cross-sections
implemented in PUMAS for radiative processes. These DCSs are available as a
function with [synopsis](#dcssynopsis) and [arguments](#dcsarguments) detailed
below.  DCSs are indexed by `string` tag indicating the corresponding radiative
process and optionally a specific parameterization. If not specified the DCS
corresponding to PUMAS's default parameterization is returned.  Available
[parameterizations](#dcsparameterization) are listed in the table below. New
parameterizations can be registered as well following the same semantic.
{: .justify}

#### DCS parameterizations

| Key | Description |
|-----|-------|
| *bremsstrahlung* {: .nowrap}     | Default Bremsstrahlung DCS, i.e. KKP parameterization. {: .justify} |
| *bremsstrahlung SSR* {: .nowrap} | Sandrock, Soedingresko and Rhode (SSR) parameterization of the Bremsstrahlung DCS, [ICRC 2019](https://arxiv.org/abs/1910.07050). {: .justify} |
| *bremsstrahlung KKP* {: .nowrap} | Kelner, Kokoulin and Petruhkin (KKP) parameterization of the Bremsstrahlung DCS, [Moscow Engineering Physics Inst., Moscow, 1995](https://cds.cern.ch/record/288828/files/MEPHI-024-95.pdf). {: .justify} |
| *bremsstrahlung ABB* {: .nowrap} | Andreev, Bezrukov and Bugaev (ABB) parameterization of the Bremsstrahlung DCS, [Physics of Atomic Nuclei 57 (1994) 2066](https://inis.iaea.org/search/searchsinglerecord.aspx?recordsFor=SingleRecord&RN=26072419). {: .justify} |
|||
| *pair_production* {: .nowrap}    | Default $e^+e^-$ pair production DCS, i.e. KKP parameterization. {: .justify} |
| *pair_production SSR* {: .nowrap}| Sandrock, Soedingresko and Rhode (SSR) parameterization of the Bremsstrahlung DCS, [ICRC 2019](https://arxiv.org/abs/1910.07050). {: .justify} |
| *pair_production KKP* {: .nowrap}| Kelner, Kokoulin and Petruhkin (KKP) parameterization of the $e^+e^-$ pair production DCS, see e.g. [ICRC 1969](http://adsabs.harvard.edu/pdf/1970ICRC....4..277K). {: .justify} |
|||
| *photonuclear* {: .nowrap}       | Default photonuclear DCS, i.e. DRSS parameterization. {: .justify} |
| *photonuclear BBKS* {: .nowrap}  | Bezrukov, Bugaev, Kokoulin and Shlepin (BBKS) parameterisation of the photonuclear DCS, see e.g. [Phys.Rev. D67 (2003)](https://arxiv.org/abs/hep-ph/0203096). {: .justify} |
| *photonuclear BM* {: .nowrap}    | Butkevich & Mikheyev (BM) parameterisation of the photonuclear DCS, [Soviet Journal of Experimental and Theoretical Physics 95 (2002) 11](https://link.springer.com/article/10.1134/1.1499897). {: .justify} |
| *photonuclear DRSS* {: .nowrap}  | Dutta, Reno, Sarcevic and Seckel (DRSS) parameterisation of the photonuclear DCS, [Phys.Rev. D63 (2001)](https://arxiv.org/abs/hep-ph/0012350). {: .justify} |


#### DCS synopsis
```lua
dcs(Z, A, mass, energy, q)
```

#### DCS arguments

|Name|Type|Description|
|----|----|-----------|
|*Z*      |`number`| The target atom charge number.|
|*A*      |`number`| The target atom mass number, in $\text{g}/\text{mol}$.|
|*mass*   |`number`| The projectile rest mass, in $\text{GeV}/c^2$.|
|*energy* |`number`| The projectile initial kinetic energy, in $\text{GeV}$.|
|*q*      |`number`| The projectile energy loss, in $\text{GeV}$.|

#### DCS returns

The corresponding DCS value as a `number`.

|Type|Description|
|----|-----------|
|`number` | The DCS value, in $\text{m}^2 / \text{GeV}$. {: .justify} |


## Examples

``` lua
-- Get the default Bremsstrahlung DCS
local dcs = pumas.dcs.bremsstrahlung

-- Evaluate the DCS for standard rock (Z = 11, A = 22)
local v = dcs(11, 22, pumas.constants.MUON_MASS, 1, 1E-03)

-- Get the Andreev, Bezrukov and Bugaev Bremsstrahlung DCS
local dcs_ABB = pumas.dcs['bremsstrahlung ABB']
```

## See also

[build](build.md),
[CompositeMaterials](CompositeMaterials.md),
[elastic](elastic.md),
[electronic](electronic.md),
[Element](Element.md),
[Material](Material.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).
