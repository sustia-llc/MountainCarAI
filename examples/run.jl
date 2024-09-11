using MountainCarAI

# Set up the physics and world
Fa, Ff, Fg, height = create_physics()
initial_position = -0.5
initial_velocity = 0.0

(execute_ai, observe_ai) = create_world(
    Fg = Fg, Ff = Ff, Fa = Fa, 
    initial_position = initial_position, 
    initial_velocity = initial_velocity
)

# Set up simulation parameters
T_ai = 50
N_ai = 100
x_target = [0.5, 0.0]
engine_force_limit = 0.04

# Create agent 1
(compute_ai1, act_ai1, slide_ai1, future_ai1) = create_agent(
    T = T_ai,
    Fa = Fa,
    Fg = Fg,
    Ff = Ff,
    engine_force_limit = engine_force_limit,
    x_target = x_target,
    initial_position = initial_position,
    initial_velocity = initial_velocity
)

# Create agent 2
(compute_ai2, act_ai2, slide_ai2, future_ai2) = create_agent(
    T = T_ai,
    Fa = Fa,
    Fg = Fg,
    Ff = Ff,
    engine_force_limit = engine_force_limit,
    x_target = x_target,
    initial_position = initial_position,
    initial_velocity = initial_velocity
)

agents = [
    Dict(
        :act_ai => act_ai1, :future_ai => future_ai1, :compute_ai => compute_ai1, :slide_ai => slide_ai1,
        :agent_a => Float64[], :agent_f => Vector{Float64}[], :agent_x => Vector{Float64}[]
    ),
    Dict(
        :act_ai => act_ai2, :future_ai => future_ai2, :compute_ai => compute_ai2, :slide_ai => slide_ai2,
        :agent_a => Float64[], :agent_f => Vector{Float64}[], :agent_x => Vector{Float64}[]
    )
]

# Initialize the environment
env = Environment(
    T_ai = T_ai,
    agents = agents,
    execute_ai = execute_ai,
    observe_ai = observe_ai
)

# Step through actions for each agent within the environment
for _ in 1:T_ai
    step_environment!(env)
end

# Print final positions of both agents
println("Final position of Agent 1: ", env.agents[1][:agent_x][end][1])
println("Final position of Agent 2: ", env.agents[2][:agent_x][end][1])