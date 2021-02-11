# Simulation
_Metatypes for configuring and running a simulation._

## Description

A stationary muon (tau) flux can be approximated by a finite number of
independent Monte Carlo particles (events). Let us assume that the primary
(initial) flux density is known on a surface bounding the simulation space.  Let
us consider another surface of interest (detector) inside the simulation space.
The flux density on the detector surface is estimated by Monte Carlo transport
of particles from (to) the primary surface.
{: .justify}

Running a Monte Carlo simulation with PUMAS is usually done in three steps as
illustrated in the [example below](#examples).
{: .justify}

- First one creates and configure a simulation
  [Context](simulation/Context.md). This requires a set of materials tabulations
  e.g. computed beforehand with the [build](physics/build.md) function, as well
  as a [Geometry](Geometry.md) description of the simulation space. The
  simulation can be configured by selecting a specific
  transport algorithm ([Mode](simulation/Mode.md)), specifying a stop
  [Event](simulation/Event.md) e.g. a [Medium](Medium.md) change and / or an
  external [Limit](simulation/Limit.md), e.g. a minimal kinetic energy.
  {: .justify}

- Secondly a Monte Carlo particle [State](simulation/State.md) is created an
  initialised, e.g. according to the [Primary](Primary.md) flux density.
  {: .justify}

- Last the Monte Carlo particle is transported (updated) using the
  [Context.transport](simulation/Context.md#transport) method.
  {: .justify}

The two last steps are usually repeated in a loop and some property of interest
is accumated, e.g. the flux on a detector surface.
{: .justify}

In order to get more insight on the Monte Carlo transport one can attach a
[Recorder](simulation/Recorder.md) object to the simulation context. The
recorder allows to supply a callback function that is executed at each Monte
Carlo step.
{: .justify}

## Examples

```lua
-- Create a simulation context using the 'hybrid longitudinal' algorithm and a
-- uniform medium of infinite extension made of standard rock
local simulation = pumas.Context{
    physics = 'share/materials/standard',
    mode = 'hybrid longitudinal',
    geometry = 'StandardRock'
}

-- Create a Monte Carlo muon state with 100 GeV initial kinetic energy
local state = pumas.State{energy = 100}

-- Propagate the muon through the standard rock medium
simulation:transport(state)
```

## See also

[Context](simulation/Context.md),
[Event](simulation/Event.md),
[Limit](simulation/Limit.md),
[Mode](simulation/Mode.md),
[Recorder](simulation/Recorder.md),
[State](simulation/State.md).
