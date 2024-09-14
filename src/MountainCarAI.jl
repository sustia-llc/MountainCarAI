module MountainCarAI

using RxInfer
using LinearAlgebra

include("physics.jl")
include("agent.jl")
include("environment.jl")

export Environment, create_agent, create_physics, run_simulation

end
