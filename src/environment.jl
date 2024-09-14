using MountainCarAI

mutable struct Environment
    T_ai::Int
    t::Int
    agents::Vector{Dict}
    agent_states::Vector{Vector{Float64}}
    height::Function
    x_target::Vector{Float64}
    N_ai::Int
    Ff::Function
    Fg::Function

    Environment(; T_ai::Int, agents::Vector{Dict{Symbol, Any}}, x_target::Vector{Float64}, N_ai::Int, Ff::Function, Fg::Function, height::Function) = begin
        agent_states = [agent[:initial_state] for agent in agents]
        return new(T_ai, 1, agents, agent_states, height, x_target, N_ai, Ff, Fg)
    end
end

function observe_state(env::Environment, agent_index::Int)::Vector{Float64}
    return copy(env.agent_states[agent_index])
end

function execute_action!(env::Environment, agent_index::Int, action::Float64)::Nothing
    state = env.agent_states[agent_index]
    y_t, y_dot_t = state
    y_dot_t_new = y_dot_t + env.Fg(y_t) + env.Ff(y_dot_t) + env.agents[agent_index][:Fa](action)
    y_t_new = y_t + y_dot_t_new
    env.agent_states[agent_index] = [y_t_new, y_dot_t_new]
    return nothing
end

function step_environment!(env::Environment)::Nothing
    for (i, agent) in enumerate(env.agents)
        # Compute new action
        new_action = agent[:act_ai]()
        push!(agent[:agent_a], new_action)

        # Compute future prediction
        new_future = agent[:future_ai]()
        push!(agent[:agent_f], new_future)

        # Execute action and observe new state
        execute_action!(env, i, new_action)
        new_observation = observe_state(env, i)
        push!(agent[:agent_x], new_observation)

        # Update AI
        agent[:compute_ai](new_action, new_observation)
        agent[:slide_ai]()
    end
    env.t += 1
    return nothing
end

function run_simulation(; N_ai::Int=100, return_env::Bool=false)
    # Set up simulation parameters
    T_ai = 50
    x_target = [0.5, 0.0]
    initial_position = -0.5
    initial_velocity = 0.0    
    engine_force_limit1 = 0.04
    engine_force_limit2 = 0.02

    # Create physics
    Ff, Fg, height = create_physics()

    # Create two agents
    agent1 = create_agent(engine_force_limit1, initial_position, initial_velocity, T_ai, x_target, Ff, Fg)
    agent2 = create_agent(engine_force_limit2, initial_position, initial_velocity, T_ai, x_target, Ff, Fg)

    # Initialize the environment
    env = Environment(
        T_ai = T_ai,
        agents = [agent1, agent2],
        x_target = x_target,
        N_ai = N_ai,
        Ff = Ff,
        Fg = Fg,
        height = height
    )

    # Step through actions for each agent within the environment
    for _ in 1:N_ai
        step_environment!(env)
    end

    if return_env
        return env
    else
        # Return final positions of both agents
        return [env.agents[1][:agent_x][end][1], env.agents[2][:agent_x][end][1]]
    end
end

run_simulation()