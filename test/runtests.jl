using Test
using MountainCarAI

@testset "MountainCarAI Tests" begin
    @testset "Environment and Agent Creation" begin
        Fa, Ff, Fg, height = create_physics()
        execute_ai, observe_ai = create_world(Fg=Fg, Ff=Ff, Fa=Fa)
        
        T_ai = 50
        N_ai = 100
        x_target = [0.5, 0.0]
        initial_position = -0.5
        initial_velocity = 0.0
        engine_force_limit = 0.04
        
        agent_funcs = create_agent(
            T = T_ai,
            Fa = Fa,
            Fg = Fg,
            Ff = Ff,
            engine_force_limit = engine_force_limit,
            x_target = x_target,
            initial_position = initial_position,
            initial_velocity = initial_velocity
        )
        
        @test length(agent_funcs) == 4
        @test all(f -> typeof(f) <: Function, agent_funcs)
        
        agents = [Dict(
            :act_ai => agent_funcs[2], 
            :future_ai => agent_funcs[4], 
            :compute_ai => agent_funcs[1], 
            :slide_ai => agent_funcs[3],
            :agent_a => Vector{Float64}(undef, N_ai),
            :agent_f => Vector{Vector{Float64}}(undef, N_ai),
            :agent_x => Vector{Vector{Float64}}(undef, N_ai)
        )]
        
        env = Environment(
            T_ai = T_ai,
            agents = agents,
            execute_ai = execute_ai,
            observe_ai = observe_ai
        )
        
        @test env.T_ai == T_ai
        @test env.t == 1
        @test length(env.agents) == 1
    end
    
    @testset "Environment Simulation" begin
        Fa, Ff, Fg, height = create_physics()
        execute_ai, observe_ai = create_world(Fg=Fg, Ff=Ff, Fa=Fa)
        
        T_ai = 50
        N_ai = 100
        x_target = [0.5, 0.0]
        initial_position = -0.5
        initial_velocity = 0.0
        engine_force_limit = 0.04
        
        agent_funcs = create_agent(
            T = T_ai,
            Fa = Fa,
            Fg = Fg,
            Ff = Ff,
            engine_force_limit = engine_force_limit,
            x_target = x_target,
            initial_position = initial_position,
            initial_velocity = initial_velocity
        )
        
        agents = [Dict(
            :act_ai => agent_funcs[2], 
            :future_ai => agent_funcs[4], 
            :compute_ai => agent_funcs[1], 
            :slide_ai => agent_funcs[3],
            :agent_a => Vector{Float64}(undef, N_ai),
            :agent_f => Vector{Vector{Float64}}(undef, N_ai),
            :agent_x => Vector{Vector{Float64}}(undef, N_ai)
        )]
        
        env = Environment(
            T_ai = T_ai,
            agents = agents,
            execute_ai = execute_ai,
            observe_ai = observe_ai
        )
        
        for _ in 1:T_ai
            step_environment!(env)
        end
        
        final_position = env.agents[1][:agent_x][end][1]
        @test isapprox(final_position, x_target[1], atol=0.1)
    end
end