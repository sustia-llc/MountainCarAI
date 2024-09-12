# MountainCarAI

This project implements Active Inference agents in an Environment for the Mountain Car problem using the RxInfer.jl package.

```mermaid
sequenceDiagram
    participant E as Environment
    participant W as World
    participant A as Agent

    E->>E: Initialize environment
    W->>W: Initialize world
    A->>A: Initialize agent

    loop For each time step
        A->>A: act_ai()
        A->>E: new_action
        E->>A: Store new_action

        A->>A: future_ai()
        A->>E: new_future
        E->>A: Store new_future

        E->>W: execute_ai(new_action, agent_state)
        W->>E: Update agent_state

        E->>W: observe_ai(agent_state)
        W->>E: new_observation
        E->>A: Store new_observation

        A->>A: compute_ai(new_action, new_observation)
        A->>A: slide_ai()

        E->>E: Increment time step
    end

    E->>E: Print final state
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