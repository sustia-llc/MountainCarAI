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

        agent1, execute_ai1, observe_ai1, initial_state1, height1, Fa1 = create_agent_and_world(
            engine_force_limit1, initial_position, initial_velocity, T_ai, x_target
        )
        agent2, execute_ai2, observe_ai2, initial_state2, height2, Fa2 = create_agent_and_world(
            engine_force_limit2, initial_position, initial_velocity, T_ai, x_target
        )

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
        
        @test env.T_ai == T_ai
        @test env.t == 1
        @test length(env.agents) == 2
        @test length(env.execute_ai) == 2
        @test length(env.observe_ai) == 2
        @test length(env.agent_states) == 2
    end
    
    @testset "Environment Simulation" begin
        final_positions =  run_simulation()
        @test isapprox(final_positions[1], 0.72, atol=0.01)
        @test isapprox(final_positions[2], -0.33, atol=0.01)
    end
end