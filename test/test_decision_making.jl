module TestDecisionMaking
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/markov_decision_process/policy_evaluator.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/markov_decision_process/dynamic_programming.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/markov_decision_process/anime_mdp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/markov_decision_process/draw_value_heatmap.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/reinforcement_learning/state_info.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/reinforcement_learning/q_learning/anime_q_learning.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/reinforcement_learning/sarsa/sarsa_agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/reinforcement_learning/sarsa/anime_sarsa.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/puddle/puddle.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/robot/warp_robot/warp_robot.jl"))

  function main()
    @testset "PolicyEvaluator" begin
      g = Goal(4.0, 4.0)
      pd = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1)]
      pe = PolicyEvaluator([0.2, 0.2, pi/18], g, pd, 0.1, 10)
      @test pe.pose_min == [-4.0, -4.0, 0.0]
      @test pe.pose_max == [4.0, 4.0, 2*pi]
      @test pe.widths == [0.2, 0.2, pi/18]
      @test pe.goal == g
      @test pe.delta_time == 0.1
      @test pe.puddle_coef == 100
      @test pe.index_nums == [40, 40, 36]
      nx, ny, nt = pe.index_nums[1], pe.index_nums[2], pe.index_nums[3]
      @test pe.indexes == vec(collect(Base.product(0:nx-1, 0:ny-1, 0:nt-1)))
      @test get_index(pe, [-4.0, -4.0, 0.0]) == [0, 0, 0]
      @test get_index(pe, [4.0, 4.0, 0.0]) == [40, 40, 0]
      @test get_index(pe, [2.9, -2.0, pi]) == [34, 10, 18]
      @test final_state(pe, (40, 40, 37)) == true
      @test final_state(pe, (1, 1, 1)) == false
      @test out_correction(pe, [1, 1, 40]) == [1, 1, 4]
    end
    @testset "DynamicProgramming" begin
      g = Goal(4.0, 4.0)
      pd = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1)]
      dp = DynamicProgramming([0.2, 0.2, pi/18], g, pd, 0.1, 10)
      @test dp.pose_min == [-4.0, -4.0, 0.0]
      @test dp.pose_max == [4.0, 4.0, 2*pi]
      @test dp.widths == [0.2, 0.2, pi/18]
      @test dp.goal == g
      @test dp.delta_time == 0.1
      @test dp.puddle_coef == 100
      @test dp.index_nums == [40, 40, 36]
      nx, ny, nt = dp.index_nums[1], dp.index_nums[2], dp.index_nums[3]
      @test dp.indexes == vec(collect(Base.product(0:nx-1, 0:ny-1, 0:nt-1)))
      @test get_index(dp, [-4.0, -4.0, 0.0]) == [0, 0, 0]
      @test get_index(dp, [4.0, 4.0, 0.0]) == [40, 40, 0]
      @test get_index(dp, [2.9, -2.0, pi]) == [34, 10, 18]
      @test final_state(dp, (40, 40, 37)) == true
      @test final_state(dp, (1, 1, 1)) == false
      @test out_correction(dp, [1, 1, 40]) == ([1, 1, 4], 0.0)
      @test out_correction(dp, [-1, 1, 40]) == ([0, 1, 4], -1e100)
      @test out_correction(dp, [40, 1, 40]) == ([39, 1, 4], -1e100)
      @test out_correction(dp, [1, -1, 40]) == ([1, 0, 4], -1e100)
      @test out_correction(dp, [1, 40, 40]) == ([1, 39, 4], -1e100)
    end
    @testset "AnimeMdp" begin
      @test_nowarn AnimeMdp.main(is_test=true)
    end
    @testset "DrawValueHeatmap" begin
      @test_nowarn DrawValueHeatmap.main(true)
    end
    @testset "StateInfo" begin
      si = StateInfo(5)
      @test length(si.q) == 5
      @test si.q == [0.0, 0.0, 0.0, 0.0, 0.0]
      @test si.epsilon == 0.3
      @test greedy(si) == 1
      @test max_q(si) == 0.0
    end
    @testset "AnimeQLearning" begin
      @test_nowarn AnimeQLearning.main(0.1, 10, is_test=true)
    end
    @testset "SarsaAgent" begin
      sa = SarsaAgent()
      @test sa.speed == 0.0
      @test sa.yaw_rate == 0.0
      @test sa.delta_time == 0.1
      @test sa.estimator === nothing
      @test sa.prev_spd == 0.0
      @test sa.prev_yr == 0.0
      @test sa.puddle_coef == 100
      @test sa.puddle_depth == 0.0
      @test sa.total_reward == 0.0
      @test sa.in_goal == false
      @test sa.final_value == 0.0
      @test sa.goal === nothing
      @test sa.pose_min == [-4.0, -4.0, 0.0]
      @test sa.pose_max == [4.0, 4.0, 2*pi]
      @test sa.widths == [0.2, 0.2, pi/18]
      @test sa.index_nums == round.(Int64, (sa.pose_max - sa.pose_min)./sa.widths)
      @test sa.alpha == 0.5
      @test sa.s === nothing
      @test sa.a === nothing
      @test sa.update_end == false
      @test sa.stuck_timer == 0.0
      @test sa.learning_timer == 0.0
      @test reward_per_sec(sa) == -1.0
      @test to_index(sa, [3.0, 3.0, 0.0]) == [35, 35, 0]
      @test to_index(sa, [5.0, 5.0, 0.0]) == [39, 39, 0]
      @test_nowarn draw_decision!(sa, [])
    end
    @testset "AnimeSarsa" begin
      @test_nowarn AnimeSarsa.main(0.1, 10, is_test=true)
    end
  end
end