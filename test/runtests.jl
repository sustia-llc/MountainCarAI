using MountainCarAI
using Test

@testset "MountainCarAI.jl" begin
    @testset "Environment Creation" begin
        T_ai = 50
        N_ai = 100
        x_target = [0.5, 0.0]
        initial_position = -0.5
        initial_velocity = 0.0
        
        engine_force_limit1 = 0.04
        engine_force_limit2 = 0.02
        physics1 = create_physics(engine_force_limit = engine_force_limit1)
        physics2 = create_physics(engine_force_limit = engine_force_limit2)
        
        execute_ai1, observe_ai1, initial_state1 = create_world(physics1, initial_position = initial_position, initial_velocity = initial_velocity)
        execute_ai2, observe_ai2, initial_state2 = create_world(physics2, initial_position = initial_position, initial_velocity = initial_velocity)
        
        agent_funcs1 = create_agent(
            T = T_ai,
            Fa = physics1[1],
            Fg = physics1[3],
            Ff = physics1[2],
            engine_force_limit = engine_force_limit1,
            x_target = x_target,
            initial_position = initial_position,
            initial_velocity = initial_velocity
        )
        
        agent_funcs2 = create_agent(
            T = T_ai,
            Fa = physics2[1],
            Fg = physics2[3],
            Ff = physics2[2],
            engine_force_limit = engine_force_limit2,
            x_target = x_target,
            initial_position = initial_position,
            initial_velocity = initial_velocity
        )
        
        agents = [
            Dict(
                :act_ai => agent_funcs1[2], 
                :future_ai => agent_funcs1[4], 
                :compute_ai => agent_funcs1[1], 
                :slide_ai => agent_funcs1[3],
                :agent_a => Float64[],
                :agent_f => Vector{Float64}[],
                :agent_x => Vector{Vector{Float64}}(undef, N_ai)
            ),
            Dict(
                :act_ai => agent_funcs2[2], 
                :future_ai => agent_funcs2[4], 
                :compute_ai => agent_funcs2[1], 
                :slide_ai => agent_funcs2[3],
                :agent_a => Float64[],
                :agent_f => Vector{Float64}[],
                :agent_x => Vector{Vector{Float64}}(undef, N_ai)
            )
        ]
        
        env = Environment(
            T_ai = T_ai,
            agents = agents,
            execute_ai = [execute_ai1, execute_ai2],
            observe_ai = [observe_ai1, observe_ai2],
            initial_states = [initial_state1, initial_state2]
        )
        
        @test env.T_ai == T_ai
        @test env.t == 1
        @test length(env.agents) == 2
        @test length(env.execute_ai) == 2
        @test length(env.observe_ai) == 2
        @test length(env.agent_states) == 2
    end
    
    @testset "Environment Simulation" begin
        T_ai = 50
        N_ai = 100
        x_target = [0.5, 0.0]
        initial_position = -0.5
        initial_velocity = 0.0
        
        engine_force_limit1 = 0.04
        engine_force_limit2 = 0.02
        physics1 = create_physics(engine_force_limit = engine_force_limit1)
        physics2 = create_physics(engine_force_limit = engine_force_limit2)
        
        execute_ai1, observe_ai1, initial_state1 = create_world(physics1, initial_position = initial_position, initial_velocity = initial_velocity)
        execute_ai2, observe_ai2, initial_state2 = create_world(physics2, initial_position = initial_position, initial_velocity = initial_velocity)
        
        agent_funcs1 = create_agent(
            T = T_ai,
            Fa = physics1[1],
            Fg = physics1[3],
            Ff = physics1[2],
            engine_force_limit = engine_force_limit1,
            x_target = x_target,
            initial_position = initial_position,
            initial_velocity = initial_velocity
        )
        
        agent_funcs2 = create_agent(
            T = T_ai,
            Fa = physics2[1],
            Fg = physics2[3],
            Ff = physics2[2],
            engine_force_limit = engine_force_limit2,
            x_target = x_target,
            initial_position = initial_position,
            initial_velocity = initial_velocity
        )
        
        agents = [
            Dict(
                :act_ai => agent_funcs1[2], 
                :future_ai => agent_funcs1[4], 
                :compute_ai => agent_funcs1[1], 
                :slide_ai => agent_funcs1[3],
                :agent_a => Float64[],
                :agent_f => Vector{Float64}[],
                :agent_x => Vector{Vector{Float64}}(undef, N_ai)
            ),
            Dict(
                :act_ai => agent_funcs2[2], 
                :future_ai => agent_funcs2[4], 
                :compute_ai => agent_funcs2[1], 
                :slide_ai => agent_funcs2[3],
                :agent_a => Float64[],
                :agent_f => Vector{Float64}[],
                :agent_x => Vector{Vector{Float64}}(undef, N_ai)
            )
        ]
        
        env = Environment(
            T_ai = T_ai,
            agents = agents,
            execute_ai = [execute_ai1, execute_ai2],
            observe_ai = [observe_ai1, observe_ai2],
            initial_states = [initial_state1, initial_state2]
        )
        
        for _ in 1:N_ai
            step_environment!(env)
        end

        final_position1 = env.agents[1][:agent_x][end][1]
        final_position2 = env.agents[2][:agent_x][end][1]
        @test isapprox(final_position1, 0.72, atol=0.01)
        @test isapprox(final_position2, -0.33, atol=0.01)
    end
end