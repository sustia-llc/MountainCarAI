mutable struct Environment
    T_ai::Int
    t::Int
    agents::Vector{Dict}
    execute_ai
    observe_ai
    Environment(; T_ai, agents, execute_ai, observe_ai) = begin
        return new(T_ai, 1, agents, execute_ai, observe_ai)
    end
end

function step_environment!(env::Environment)
    for agent in env.agents
        # Compute new action
        new_action = agent[:act_ai]()
        push!(agent[:agent_a], new_action)

        # Compute future prediction
        new_future = agent[:future_ai]()
        push!(agent[:agent_f], new_future)

        # Execute action and observe new state
        env.execute_ai(new_action)
        new_observation = env.observe_ai()
        push!(agent[:agent_x], new_observation)

        # Update AI
        agent[:compute_ai](new_action, new_observation)
        agent[:slide_ai]()
    end
    env.t += 1
end