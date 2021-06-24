# Electronic
_Functions describing collisions with atomic electrons._

## Content

The [electronic](electronic.md) sub-package contains three functions describing
collisions with atomic electrons as detailed below.
{ .justify}

## See also

[build](build.md),
[CompositeMaterials](CompositeMaterials.md),
[dcs](dcs.md),
[elastic](elastic.md),
[Element](Element.md),
[Material](Material.md),
[Physics](Physics.md),
[TabulatedMaterial](TabulatedMaterial.md).


<div markdown="1" class="shaded-box fancy">
## electronic.dcs

The effective differential cross-section for close collisions with atomic
electrons.
{: .justify}

!!! note
    This DCS only accounts for close collisions with energy transfer large
    w.r.t. the atomic binding energies. The [energy
    loss](#electronicenergy_loss) however takes into account all collisions
    with a detailed electronic structure.
    {: .justify}

---

### Synopsis

```lua
electronic.dcs(Z, A, mass, energy, q)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*Z*      |`number`| The target atom charge number.|
|*A*      |`number`| The target atom mass number, in $\text{g}/\text{mol}$.|
|*mass*   |`number`| The projectile rest mass, in $\text{GeV}/c^2$.|
|*energy* |`number`| The projectile kinetic energy, in $\text{GeV}$.|
|*q*      |`number`| The projectile energy loss, in $\text{GeV}$.|

### Returns

|Type|Description|
|----|-----------|
|`number` | The DCS value, in $\text{m}^2 / \text{GeV}$. {: .justify} |

### See also

[density\_effect](#electronicdensity_effect),
[energy\_loss](#electronicenergy_loss).
</div>


<div markdown="1" class="shaded-box fancy">
## electronic.density\_effect

The Fermi density effect for collisions with atomic electrons, $\delta_F$. This
functions has two forms as detailed in the synopsis below. In the fist form a
single atomic element is expected, i.e. *Z* and *A* are numbers. In the second
form a mixture is provided with *Z*, *A* and weights, *w*, provided as tables.
{: .justify}

---

### Synopsis

```lua
electronic.density_effect(Z, A, I, density, gamma)

electronic.density_effect(Z, A, w, I, density, gamma)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*Z*       |`number` or `table`| The target atom(s) charge number. {: .justify}|
|*A*       |`number` or `table`| The target atom(s) mass number, in $\text{g}/\text{mol}$. {: .justify}|
|*I*       |`number`           | The target mean excitation energy, in $\text{GeV}$. {: .justify}|
|*density* |`number`           | The target density, in $\text{kg} / \text{m}^3$. {: .justify}|
|*gamma*   |`number`           | The projectile relativistic $\gamma$ factor. {: .justify}|



### Returns

|Type|Description|
|----|-----------|
|`number` | The Fermi density effect, $\delta_F$. {: .justify} |

### See also

[dcs](#electronicdcs),
[energy\_loss](#electronicenergy_loss).
</div>


<div markdown="1" class="shaded-box fancy">
## electronic.energy\_loss

The energy loss for collisions with atomic electrons, $\frac{dE}{dX}$. This
functions has two forms as detailed in the synopsis below. In the fist form a
single atomic element is expected, i.e. *Z* and *A* are numbers. In the second
form a mixture is provided with *Z*, *A* and weights, *w*, provided as tables.
{: .justify}

---

### Synopsis

```lua
electronic.energy_loss(Z, A, I, density, mass, energy)

electronic.energy_loss(Z, A, w, I, density, mass, energy)
```

### Arguments

|Name|Type|Description|
|----|----|-----------|
|*Z*       |`number` or `table`| The target atom(s) charge number. {: .justify}|
|*A*       |`number` or `table`| The target atom(s) mass number, in $\text{g}/\text{mol}$. {: .justify}|
|*I*       |`number`           | The target mean excitation energy, in $\text{GeV}$. {: .justify}|
|*density* |`number`           | The target density, in $\text{kg} / \text{m}^3$. {: .justify}|
|*mass*    |`number`           | The projectile rest mass, in $\text{GeV} / c^2$. {: .justify}|
|*energy*  |`number`           | The projectile kinetic energy, in $\text{GeV}$. {: .justify}|



### Returns

|Type|Description|
|----|-----------|
|`number` | The electronic energy loss per unit mass, $\frac{dE}{dX}$, in $\text{GeV} \text{m}^2 / \text{kg}$. {: .justify} |

### See also

[dcs](#electronicdcs),
[density\_effect](#electronicdensity_effect).
</div>
