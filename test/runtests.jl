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

        # Create physics
        physics = create_physics()

        agent1 = create_agent(engine_force_limit1, initial_position, initial_velocity, T_ai, x_target, physics)
        agent2 = create_agent(engine_force_limit2, initial_position, initial_velocity, T_ai, x_target, physics)

        env = Environment(
            T_ai = T_ai,
            agents = [agent1, agent2],
            x_target = x_target,
            N_ai = N_ai,
            physics = physics
        )
        
        @test env.T_ai == T_ai
        @test env.t == 1
        @test length(env.agents) == 2
    end
    
    @testset "Environment Simulation" begin
        final_positions =  run_simulation()
        @test isapprox(final_positions[1], 0.72, atol=0.01)
        @test isapprox(final_positions[2], -0.33, atol=0.01)
    end
end