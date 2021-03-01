# MuonFlux
_A metatype for representing a primary flux of atmospheric muons._


<div markdown="1" class="shaded-box fancy">
## Attributes

|Name|Type|Description|
|----|----|-----------|
|*model*   |`string`         | Reference model for atmospheric muon spectra. |
|*altitude*|`number` or `nil`| Model default altitude, in m. {: .justify}    |

!!! note
    Attributes are readonly. The model cannot be modified once created. Instead
    one must create a new [MuonFlux](MuonFlux.md) object.
    {: .justify}
</div>


<div markdown="1" class="shaded-box fancy">
## Constructor

The [MuonFlux](MuonFlux.md) constructor requires a spectrum model to be provided
as first argument. Optionally one can also provide a default model altitude as
well as a specific vertical axis or origin. If not specified spectrum models are
provided w.r.t. the local vertical using the WGS84 ellipsoid (GPS altitude).
Available models are listed in the table below. Their altitude (range) is also
indicated.
{: .justify}

|Name|Altitude (m)|Description|
|----|:------:|-----------|
|`'chirkin'`  | 0      | Parametric model from [Chirkin, 2003](https://arxiv.org/abs/hep-ph/0407078). |
|`'gaisser'`  | 0      | Gaisser's semi-analytical model, see e.g. [Zyla _et al._, 2020](https://pdg.lbl.gov/2020/reviews/rpp2020-rev-cosmic-rays.pdf). {: .justify} |
|`'gccly'`    | 0      | Parametric model from [Guan _et al._, 2015](https://arxiv.org/abs/1509.06176). |
|`'mceq'`     | 0-9000 | Tabulation of [MCEq](https://github.com/afedynitch/MCEq) results. Production yields have been weighted according to the global fit to experimental data of [Yanez _et al._, 2019](https://arxiv.org/abs/1909.08365). {: .justify} |

!!! warning
    The `'chirkin'`, `'gaisser'` and `'gccly'` models are only provided at
    sea level. No correction is applied if they are used at another altitude.
    {: .justify}

### Synopsis

```lua
pumas.MuonFlux{(altitude)=, (axis)=, (charge_ratio)=, (gamma)=, (model)=,
    (normalisation)=, (origin)=})
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|(*altitude*)|`number`                                    | Default model altitude, in `m`. If specified this sets the sampling altitude of the [sample](muonfluxsample) method. {: .justify} |
|(*axis*)    |`string` or [Coordinates](../Coordinates.md)| Vertical axis of the flux model. Defaults to `'vertical'` i.e. the local vertical is used assuming Earth-Centered Earth-Fixed (ECEF) coordinates for the simulation frame. Alternativelly if [Coordinates](../Coordinates.md) are provided a constant vertical axis is used. {: .justify} |
|(*charge_ratio*)  |`number`                              | Constant charge ratio ($\mu^+ / \mu^-$) for semi-analytical models. Defaults to `1.2766` as measured by [CMS](https://arxiv.org/abs/1005.5332). {: .justify} |
|(*gamma*)  |`number`                                     | Spectral exponent for semi-analytical models. The default value depends on the model, e.g. $\gamma = 2.7$ for `'gaisser'` model. {: .justify} |
|*(model)*   |`string`                                    | Reference model for atmospheric muon spectra. One of `'chirkin'`, `'gaisser'`, `'gccly'` or `'mceq'`. Defaults to `'mceq'`. {: .justify} |
|(*normalisation*)  |`number`                             | Flux relative normalization. Defaults to `1`, i.e. native model values are used. {: .justify} |
|(*origin*)  |[Coordinates](../Coordinates.md)            | Origin of the flux model, in m. Defaults to the WGS84 ellipsoid if a local vertical *axis* is used or to the origin of the simulation frame otherwise. {: .justify} |
</div>


<div markdown="1" class="shaded-box fancy">
## MuonFlux.sample

Sample the primary [MuonFlux](MuonFlux.md) for a given particle
[State](../simulation/State.md). If a default *altitude* was specified when
creating the [MuonFlux](MuonFlux.md) object then it is also checked that the
particle reached the corresponding value. On success the particle *weight* is
updated by the sampled flux value.
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
|`boolean`         | `false` if a primary flux altitude was specified but not reached by the particle, `true` otherwise. {: .justify}|
|`number` or `nil` | Value of the sampled flux on success otherwise `nil`. {: .justify} |

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
observation zenith angle. Optionally a specific *charge* and *altitude* can be
requested. If no *charge* is provided then the total flux is returned, i.e. for
both charges. If no *altitude* is provided then the default value of the
[MuonFlux](MuonFlux.md) object is used. If the [MuonFlux](MuonFlux.md) object
has no default altitude then a value of `0` m is assumed.
{: .justify}

!!! note
    The cosine of the observation zenith angle and the altitude have to be
    provided in the native frame of the model not in the simulation one. The
    zenith angle corresponds to the opposite of the direction of propagation of
    the muon.  E.g. a cosine value of `1` indicates a vertically down going
    muon.
    {: .justify}

---

### Synopsis

```lua
MuonFlux:spectrum(kinetic_energy, cos_theta, (charge)=, (altitude)=)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*kinetic\_energy*|`number`| Muon kinetic energy, in GeV. {: .justify} |
|*cos\_theta*     |`number`| Cosine of the observation angle (see above). {: .justify} |
|(*charge*)       |`number`| Muon electric charge. If `0` or `nil` the total flux is returned, i.e. for both charges. {: .justify} |
|(*altitude*)     |`number`| Model altitude, in `m`. See above for default value. {: .justify} |

### Returns

|Type|Description|
|----|-----------|
|`number`| Value of the differential flux for the requested parameters. {:.justify}|

### See also

[sample](#muonfluxsample).
</div>
