using MountainCarAI

mutable struct Environment
    T_ai::Int
    t::Int
    agents::Vector{Dict}
    execute_ai::Vector
    observe_ai::Vector
    agent_states::Vector{Vector{Float64}}  # Store each agent's state
    heights::Vector{Function}
    x_target::Vector{Float64}
    N_ai::Int
    Fas::Vector{Function}

    Environment(; T_ai, agents, execute_ai, observe_ai, initial_states, heights, x_target, N_ai, Fas) = begin
        return new(T_ai, 1, agents, execute_ai, observe_ai, initial_states, heights, x_target, N_ai, Fas)
    end
end

function step_environment!(env::Environment)
    for (i, agent) in enumerate(env.agents)
        # Compute new action
        new_action = agent[:act_ai]()
        push!(agent[:agent_a], new_action)

        # Compute future prediction
        new_future = agent[:future_ai]()
        push!(agent[:agent_f], new_future)

        # Execute action and observe new state
        env.execute_ai[i](new_action, env.agent_states[i])
        new_observation = env.observe_ai[i](env.agent_states[i])
        push!(agent[:agent_x], new_observation)

        # Update AI
        agent[:compute_ai](new_action, new_observation)
        agent[:slide_ai]()
    end
    env.t += 1
end

function create_agent_and_world(engine_force_limit, initial_position, initial_velocity, T_ai, x_target)
    Fa, Ff, Fg, height = create_physics(engine_force_limit = engine_force_limit)
    execute_ai, observe_ai, initial_state = create_world(
        (Fa, Ff, Fg, height),
        initial_position = initial_position, 
        initial_velocity = initial_velocity
    )
    (compute_ai, act_ai, slide_ai, future_ai) = create_agent(
        T = T_ai, Fa = Fa, Fg = Fg, Ff = Ff,
        engine_force_limit = engine_force_limit,
        x_target = x_target,
        initial_position = initial_position,
        initial_velocity = initial_velocity
    )
    agent = Dict(
        :act_ai => act_ai, :future_ai => future_ai, :compute_ai => compute_ai, :slide_ai => slide_ai,
        :agent_a => Float64[], :agent_f => Vector{Float64}[], :agent_x => Vector{Float64}[]
    )
    return agent, execute_ai, observe_ai, initial_state, height, Fa
end

function run_simulation(; N_ai=100, return_env=false)
    # Set up simulation parameters
    T_ai = 50
    x_target = [0.5, 0.0]

    initial_position = -0.5
    initial_velocity = 0.0    

    engine_force_limit1 = 0.04
    engine_force_limit2 = 0.02

    # Create two agents and corresponding worlds
    # TODO: return a tuple for the world, similar to agent
    agent1, execute_ai1, observe_ai1, initial_state1, height1, Fa1 = create_agent_and_world(
        engine_force_limit1, initial_position, initial_velocity, T_ai, x_target
    )
    agent2, execute_ai2, observe_ai2, initial_state2, height2, Fa2 = create_agent_and_world(
        engine_force_limit2, initial_position, initial_velocity, T_ai, x_target
    )

    # Initialize the environment
    env = Environment(
        T_ai = T_ai,
        agents = [agent1, agent2],
        execute_ai = [execute_ai1, execute_ai2],
        observe_ai = [observe_ai1, observe_ai2],
        initial_states = [initial_state1, initial_state2],
        heights = [height1, height2],
        x_target = x_target,
        N_ai = N_ai,
        Fas = [Fa1, Fa2]
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