# MountainCarAI

This project implements Active Inference agents in an Environment for the Mountain Car problem using the RxInfer.jl package.

```mermaid
sequenceDiagram
    participant E as Environment
    participant A as Agent    
    participant P as Physics

    E->>P: Create physics
    P-->>E: Fg, Ff, height
    E->>A: Create agent
    A-->>E: Agent
    E->>E: Initialize environment

    Note over E: step_environment!
    E->>A: act_ai()
    A-->>E: new_action
    E->>A: Store new_action

    E->>A: future_ai()
    A-->>E: new_future
    E->>A: Store new_future

    E->>E: execute_action!(new_action, agent)
    E->>E: Update agent_state

    E->>E: observe_state(agent_state)
    E->>A: Store new_observation

    E->>A: compute_ai(new_action, new_observation)
    E->>A: slide_ai()

    Note over E: Increment time step
```

## Installation

### Install Julia
https://julialang.org/downloads/

### Download Source
* Clone this repository
* Navigate to the project directory

## Run

Start Julia and activate the project:

```julia
using Pkg; Pkg.activate("."); Pkg.instantiate()

# To run the example with two agents:
include("examples/run.jl")
```

## Run Tests
```julia
using Pkg
Pkg.test()
```

## Acknowledgments
* Based on the [Active Inference Mountain car example](https://github.com/ReactiveBayes/RxInfer.jl/blob/main/examples/advanced_examples/Active%20Inference%20Mountain%20car.ipynb) from RxInfer.jl