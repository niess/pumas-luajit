# MuonFlux
_A metatype for representing a primary flux of atmospheric muons._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*model*   |`string`| Reference model for atmospheric muon spectra. |
|*altitude*|`number`| Sampling altitude w.r.t. the ellipsoid (GPS altitude), in m. {: .justify} |

!!! note
    Attributes are readonly. The model cannot be modified once created. Instead
    one must create a new [MuonFlux](MuonFlux.md) object.
    {: .justify}
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The [MuonFlux](MuonFlux.md) constructor requires a spectrum model to be provided
as first argument. Optionally one can also provide a sampling altitude as well
as a specific vertical axis or origin for the model. By default spectrum models
are provided w.r.t. local vertical using the WGS84 ellipsoid (GPS altitude).
Available models are listed in the table below. Their altitude (range) is also
indicated.
{: .justify}

|Name|Altitude (m)|Description|
|----|:------:|-----------|
|`'chirkin'`  | 0      | Parametric model from [Chirkin, 2003](https://arxiv.org/abs/hep-ph/0407078). |
|`'gaisser'`  | 0      | Gaisser's semi-analytical model, see e.g. [Zyla _et al._, 2020](https://pdg.lbl.gov/2020/reviews/rpp2020-rev-cosmic-rays.pdf). {: .justify} |
|`'gccly'`    | 0      | Parametric model from [Guan _et al._, 2015](https://arxiv.org/abs/1509.06176). |
|`'mceq'`     | 0-9000 | Tabulation of [MCEq](https://github.com/afedynitch/MCEq) result (*conditions to be defined*). {: .justify} |

!!! warning
    The `'chirkin'`, `'gaisser'` and `'gccly'` models are only provided at
    sea level. No correction is applied if they are used at another altitude.
    {: .justify}

### Synopsis

```lua
pumas.MuonFlux(model, {(altitude)=, (axis)=, (origin)=})
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*model*     |`string`                                    | Reference model for atmospheric muon spectra. One of `'chirkin'`, `gaisser`, `gccly` or `tabulated`. {: .justify} |
|||
|(*altitude*)|`number`                                    | Sampling altitude w.r.t. the ellipsoid (GPS altitude), in m. Defaults to `0` m. {: .justify} |
|(*axis*)    |`string` or [Coordinates](../Coordinates.md)| Vertical axis of the flux model. Defaults to `'vertical'` i.e. the local vertical is used assuming Earth-Centered Earth-Fixed (ECEF) coordinates for the simulation frame. Alternativelly if [Coordinates](../Coordinates.md) are provided a constant vertical axis is used. {: .justify} |
|(*origin*)  |[Coordinates](../Coordinates.md)            | Origin of the flux model, in m. Defaults to the WGS84 ellipsoid if a local vertical *axis* is used or to the origin of the simulation frame otherwise. {: .justify} |
</div>


<div markdown="1" class="shaded-box fancy">
## MuonFlux.sample

Sample the primary [MuonFlux](MuonFlux.md) for a given particle
[State](../simulation/State.md). On success the particle *weight* is updated
by the sampled flux value.
{: .justify}

---

### Synopsis

```lua
MuonFlux:sample(state)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*state*|[State](../simulation/State.md)| Particle state sampling the primary muon flux. {: .justify} |

### Returns

|Type|Description|
|----|-----------|
|`boolean`| `true` if the particle was sampled, e.g. it reached the primary flux altitude, `false` otherwise. {: .justify}|
|`number` | Value of the sampled flux.|

!!! note
    On success the Monte Carlo weight of the input
    [State](../simulation/State.md) is updated by the sampled flux value.
    {: .justify}

### See also

[spectrum](#muonfluxspectrum).
</div>


<div markdown="1" class="shaded-box fancy">
## MuonFlux.spectrum

Evaluate the differential muon flux for a given kinetic energy and cosine of the
observation zenith angle. Optionally a specific *charge* can be requested. If
not provided the total flux is returned, i.e. for both charges.
{: .justify}

!!! note
    The observation zenith angle has to be provided in the native frame of the
    model not in the simulation one. It corresponds to the opposite of the
    direction of propagation of the muon. E.g. a value of `1` indicates a
    vertically down going muon.
    {: .justify}

---

### Synopsis

```lua
MuonFlux:spectrum(kinetic_energy, cos_theta, (charge)=)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*kinetic\_energy*|`number`| Muon kinetic energy, in GeV. {: .justify} |
|*cos\_theta*     |`number`| Cosine of the observation angle (see above). {: .justify} |
|(*charge*)       |`number`| Muon electric charge. If `0` or `nil` the the total flux is returned, i.e. for both charges. {: .justify} |

### Returns

|Type|Description|
|----|-----------|
|`number`| Value of the differential flux for the requested parameters. {:.justify}|

### See also

[sample](#muonfluxsample).
</div>
