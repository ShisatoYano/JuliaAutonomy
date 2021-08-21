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
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/reinforcement_learning/n_step_sarsa/n_step_sarsa_agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/reinforcement_learning/n_step_sarsa/anime_n_step_sarsa.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/reinforcement_learning/sarsa_lambda/sarsa_lambda_agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/reinforcement_learning/sarsa_lambda/anime_sarsa_lambda.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/q_mdp_agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/value_heatmap_amdp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/pfc_agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/dp_for_pfc.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/belief_dynamic_programming.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/anime_amdp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/anime_pfc.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/anime_dp_mcl.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/partially_observable_mdp/amdp_policy_agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/map/map.jl"))
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
    @testset "BeliefDynamicProgramming" begin
      g = Goal(4.0, 4.0)
      s = Sensor(Map(), dist_noise_rate=0.1, dir_noise=pi/90)
      pd = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1)]
      bdp = BeliefDynamicProgramming([0.2, 0.2, pi/18], g, pd, 0.1, 10, s)
      @test bdp.pose_min == [-4.0, -4.0, 0.0]
      @test bdp.pose_max == [4.0, 4.0, 2*pi]
      @test bdp.widths == [0.2, 0.2, pi/18]
      @test bdp.goal == g
      @test bdp.delta_time == 0.1
      @test bdp.puddle_coef == 100
      @test bdp.dev_borders == [0.1, 0.2, 0.4, 0.8]
      @test bdp.dev_borders_side == [0.01, 0.1, 0.2, 0.4, 0.8, 8.0]
      @test bdp.index_nums == [40, 40, 36, 4]
      nx, ny, nt, nh = bdp.index_nums[1], bdp.index_nums[2], bdp.index_nums[3], bdp.index_nums[4]
      @test bdp.indexes == vec(collect(Base.product(0:nx-1, 0:ny-1, 0:nt-1, 0:nh-1)))
      @test get_index(bdp, [-4.0, -4.0, 0.0]) == [0, 0, 0]
      @test get_index(bdp, [4.0, 4.0, 0.0]) == [40, 40, 0]
      @test get_index(bdp, [2.9, -2.0, pi]) == [34, 10, 18]
      @test belief_final_state(bdp, (40, 40, 37)) == true
      @test belief_final_state(bdp, (1, 1, 1)) == false
      @test out_correction(bdp, [1, 1, 40]) == ([1, 1, 4], 0.0)
      @test out_correction(bdp, [-1, 1, 40]) == ([0, 1, 4], -1e100)
      @test out_correction(bdp, [40, 1, 40]) == ([39, 1, 4], -1e100)
      @test out_correction(bdp, [1, -1, 40]) == ([1, 0, 4], -1e100)
      @test out_correction(bdp, [1, 40, 40]) == ([1, 39, 4], -1e100)
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
    @testset "NstepSarsaAgent" begin
      nsa = NstepSarsaAgent()
      @test nsa.speed == 0.0
      @test nsa.yaw_rate == 0.0
      @test nsa.delta_time == 0.1
      @test nsa.estimator === nothing
      @test nsa.prev_spd == 0.0
      @test nsa.prev_yr == 0.0
      @test nsa.puddle_coef == 100
      @test nsa.puddle_depth == 0.0
      @test nsa.total_reward == 0.0
      @test nsa.in_goal == false
      @test nsa.final_value == 0.0
      @test nsa.goal === nothing
      @test nsa.pose_min == [-4.0, -4.0, 0.0]
      @test nsa.pose_max == [4.0, 4.0, 2*pi]
      @test nsa.widths == [0.2, 0.2, pi/18]
      @test nsa.index_nums == round.(Int64, (nsa.pose_max - nsa.pose_min)./nsa.widths)
      @test nsa.alpha == 0.5
      @test nsa.s === nothing
      @test nsa.a === nothing
      @test nsa.update_end == false
      @test nsa.stuck_timer == 0.0
      @test nsa.learning_timer == 0.0
      @test nsa.s_trace == []
      @test nsa.a_trace == []
      @test nsa.r_trace == []
      @test nsa.n_step == 10
      @test reward_per_sec(nsa) == -1.0
      @test to_index(nsa, [3.0, 3.0, 0.0]) == [35, 35, 0]
      @test to_index(nsa, [5.0, 5.0, 0.0]) == [39, 39, 0]
      @test_nowarn draw_decision!(nsa, [])
    end
    @testset "AnimeNstepSarsa" begin
      @test_nowarn AnimeNstepSarsa.main(0.1, 10, is_test=true)
    end
    @testset "SarsaLambdaAgent" begin
      sla = SarsaLambdaAgent()
      @test sla.speed == 0.0
      @test sla.yaw_rate == 0.0
      @test sla.delta_time == 0.1
      @test sla.estimator === nothing
      @test sla.prev_spd == 0.0
      @test sla.prev_yr == 0.0
      @test sla.puddle_coef == 100
      @test sla.puddle_depth == 0.0
      @test sla.total_reward == 0.0
      @test sla.in_goal == false
      @test sla.final_value == 0.0
      @test sla.goal === nothing
      @test sla.pose_min == [-4.0, -4.0, 0.0]
      @test sla.pose_max == [4.0, 4.0, 2*pi]
      @test sla.widths == [0.2, 0.2, pi/18]
      @test sla.index_nums == round.(Int64, (sla.pose_max - sla.pose_min)./sla.widths)
      @test sla.alpha == 0.5
      @test sla.s === nothing
      @test sla.a === nothing
      @test sla.update_end == false
      @test sla.stuck_timer == 0.0
      @test sla.learning_timer == 0.0
      @test sla.s_trace == []
      @test sla.a_trace == []
      @test sla.lmd == 0.9
      @test reward_per_sec(sla) == -1.0
      @test to_index(sla, [3.0, 3.0, 0.0]) == [35, 35, 0]
      @test to_index(sla, [5.0, 5.0, 0.0]) == [39, 39, 0]
      @test_nowarn draw_decision!(sla, [])
    end
    @testset "AnimeSarsaLambda" begin
      @test_nowarn AnimeSarsaLambda.main(0.1, 10, is_test=true)
    end
    @testset "ValueHeatmapAmdp" begin
      @test_nowarn ValueHeatmapAmdp.main(true)
    end
    @testset "DpForPfc" begin
      @test_nowarn DpForPfc.main(true)
    end
    @testset "QmdpAgent" begin
      g = Goal(4.0, 4.0)
      ps = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1)]
      qma = QmdpAgent(goal=g, puddles=ps)
      @test qma.speed == 0.0
      @test qma.yaw_rate == 0.0
      @test qma.delta_time == 0.1
      @test qma.estimator === nothing
      @test qma.prev_spd == 0.0
      @test qma.prev_yr == 0.0
      @test qma.puddle_coef == 100
      @test qma.puddle_depth == 0.0
      @test qma.total_reward == 0.0
      @test qma.in_goal == false
      @test qma.final_value == 0.0
      @test qma.goal == g
      @test qma.pose_min == [-4.0, -4.0, 0.0]
      @test qma.pose_max == [4.0, 4.0, 2*pi]
      @test qma.widths == [0.2, 0.2, pi/18]
      @test qma.index_nums == round.(Int64, (qma.pose_max - qma.pose_min)./qma.widths)
      @test qma.evaluations == [0.0, 0.0, 0.0]
      @test qma.current_value == 0.0
      @test qma.stop_timer == 0.0
      @test reward_per_sec(qma) == -1.0
      @test to_index(qma, [3.0, 3.0, 0.0]) == [35, 35, 0]
      @test to_index(qma, [5.0, 5.0, 0.0]) == [39, 39, 0]
      @test_nowarn draw_decision!(qma, [])
    end
    @testset "PfcAgent" begin
      g = Goal(4.0, 4.0)
      ps = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1)]
      pfc = PfcAgent(goal=g, puddles=ps)
      @test pfc.speed == 0.0
      @test pfc.yaw_rate == 0.0
      @test pfc.delta_time == 0.1
      @test pfc.estimator === nothing
      @test pfc.prev_spd == 0.0
      @test pfc.prev_yr == 0.0
      @test pfc.puddle_coef == 100
      @test pfc.puddle_depth == 0.0
      @test pfc.total_reward == 0.0
      @test pfc.in_goal == false
      @test pfc.final_value == 0.0
      @test pfc.goal == g
      @test pfc.pose_min == [-4.0, -4.0, 0.0]
      @test pfc.pose_max == [4.0, 4.0, 2*pi]
      @test pfc.widths == [0.2, 0.2, pi/18]
      @test pfc.index_nums == round.(Int64, (pfc.pose_max - pfc.pose_min)./pfc.widths)
      @test pfc.evaluations == [0.0, 0.0, 0.0]
      @test pfc.current_value == 0.0
      @test pfc.stop_timer == 0.0
      @test pfc.magnitude == 2
      @test reward_per_sec(pfc) == -1.0
      @test to_index(pfc, [3.0, 3.0, 0.0]) == [35, 35, 0]
      @test to_index(pfc, [5.0, 5.0, 0.0]) == [39, 39, 0]
      @test_nowarn draw_decision!(pfc, [])
    end
    @testset "AmdpPolicyAgent" begin
      apa = AmdpPolicyAgent()
      @test apa.speed == 0.0
      @test apa.yaw_rate == 0.0
      @test apa.delta_time == 0.1
      @test apa.estimator === nothing
      @test apa.prev_spd == 0.0
      @test apa.prev_yr == 0.0
      @test apa.puddle_coef == 100
      @test apa.puddle_depth == 0.0
      @test apa.total_reward == 0.0
      @test apa.in_goal == false
      @test apa.final_value == 0.0
      @test apa.goal === nothing
      @test apa.pose_min == [-4.0, -4.0, 0.0]
      @test apa.pose_max == [4.0, 4.0, 2*pi]
      @test apa.widths == [0.2, 0.2, pi/18]
      @test apa.index_nums == [40, 40, 36, 4]
      @test apa.dev_borders == [0.1, 0.2, 0.4, 0.8]
      @test apa.stop_timer == 0.0
      @test reward_per_sec(apa) == -1.0
      @test to_index(apa, [3.0, 3.0, 0.0]) == [35, 35, 0]
      @test to_index(apa, [5.0, 5.0, 0.0]) == [39, 39, 0]
      @test_nowarn draw_decision!(apa, [])
    end
    @testset "AnimeAmdp" begin
      @test_nowarn AnimeAmdp.main(0.1, 10, is_test=true)
    end
    @testset "AnimeDpMcl" begin
      @test_nowarn AnimeDpMcl.main(0.1, 10, is_test=true)
    end
    @testset "AnimePfc" begin
      @test_nowarn AnimePfc.main(0.1, 10, is_test=true)
    end
  end
end