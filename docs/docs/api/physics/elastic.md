# Elastic
_Functions describing elastic interactions._

## Content

The [elastic](elastic.md) sub-package contains two functions describing
elastic interactions as detailed below.
{ .justify}

## See also

[CompositeMaterials](CompositeMaterials.md),
[dcs](dcs.md),
[Element](Element.md),
[Material](Material.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).


<div markdown="1" class="shaded-box fancy">
## elastic.dcs

The differential cross-section for elastic processes.
{: .justify}

!!! note
    Contrary to radiative processes (see the [dcs](dcs.md) sub-package) the
    elastic differential cross-section is given w.r.t. the polar angle of
    deflection, $\theta$, not w.r.t. the energy loss, $q$. For $\mu$ and $\tau$
    leptons, the energy loss due to elastic processes is negligible compared to
    other processes, e.g. electronic losses. In PUMAS, elastic processes are
    approximated as strictly lossless.
    {: .justify}

---

### Synopsis

```lua
elastic.dcs(Z, A, mass, energy, theta)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*Z*      |`number`| The target atom charge number.|
|*A*      |`number`| The target atom mass number, in $\text{g}/\text{mol}$.|
|*mass*   |`number`| The projectile rest mass, in $\text{GeV}/c^2$.|
|*energy* |`number`| The projectile kinetic energy, in $\text{GeV}$.|
|*theta*  |`number`| The deflection angle, in $\text{rad}$.|

### Returns

|Type|Description|
|----|-----------|
|`number` | The DCS value, in $\text{m}^2 / \text{rad}$. {: .justify} |

### See also

[length](#elasticlength).
</div>


<div markdown="1" class="shaded-box fancy">
## elastic.length

The interaction length of the first transport path length for elastic processes.
{: .justify}

---

### Synopsis

```lua
elastic.length(order, Z, A, mass, energy)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*order*  |`number`| The order of integration. Must be `0` or `1` for the interaction length of the first transport path length, respectively. { .justify} |
|*Z*      |`number`| The target atom charge number.|
|*A*      |`number`| The target atom mass number, in $\text{g}/\text{mol}$.|
|*mass*   |`number`| The projectile rest mass, in $\text{GeV}/c^2$.|
|*energy* |`number`| The projectile kinetic energy, in $\text{GeV}$.|

### Returns

|Type|Description|
|----|-----------|
|`number` | The path length per unit mass, in $\text{kg} / \text{m}^{-2}$. {: .justify} |

### See also

[dcs](#elasticdcs).
</div>
