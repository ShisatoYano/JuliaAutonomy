# module for testing each model modules

module TestModel
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/world/puddle_world.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/agent/agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/agent/puddle_ignore_agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/agent/dp_policy_agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/map/map.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/object/object.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/sensor/sensor.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/puddle/puddle.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/movement/kidnap/anime_move_kidnap.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/movement/random_noise/anime_move_random_noise.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/movement/speed_bias/anime_move_speed_bias.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/movement/stuck/anime_move_stuck.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/observation/bias/anime_observe_bias.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/observation/noise/anime_observe_noise.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/observation/occlusion/anime_observe_occlusion.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/observation/oversight/anime_observe_oversight.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/uncertainty/observation/phantom/anime_observe_phantom.jl"))

  function main()
    @testset "Model" begin
      @testset "World" begin
        w = World(-5.0, 5.0, -5.0, 5.0)
        @test w.x_min == -5.0
        @test w.x_max == 5.0
        @test w.y_min == -5.0
        @test w.y_max == 5.0
        @test_nowarn draw(w)
      end
      @testset "PuddleWorld" begin
        pw = PuddleWorld(-5.0, 5.0, -5.0, 5.0, is_test=true)
        @test pw.x_min == -5.0
        @test pw.x_max == 5.0
        @test pw.y_min == -5.0
        @test pw.y_max == 5.0
        @test length(pw.objects) == 0
        @test pw.delta_time == 0.1
        @test pw.end_time == 30
        @test pw.is_test == true
        @test pw.save_path === nothing
        @test length(pw.puddles) == 0
        @test length(pw.robots) == 0
        @test length(pw.goals) == 0
        append(pw, DifferentialWheeledRobot([1, 1, 1], 0.5, "red", 
                                            PuddleIgnoreAgent(), 0.1))
        append(pw, Puddle([0.0, 0.0], [6.0, 6.0], 0.1))
        append(pw, Goal(1.0, 2.0, radius=0.5, value=1.0))
        @test length(pw.puddles) == 1
        @test length(pw.robots) == 1
        @test length(pw.goals) == 1
        @test puddle_depth(pw, [1.0, 1.0, 1.0]) == 0.1
        @test_nowarn draw(pw)
      end
      @testset "Agent" begin
        a = Agent(0.1, 1.0)
        obsrv = []
        speed, yaw_rate = draw_decision!(a, obsrv)
        @test speed == 0.1
        @test yaw_rate == 1.0
        @test a.time_interval == 0.1
        @test a.estimator === nothing
        @test a.prev_spd == 0.0
        @test a.prev_yr == 0.0 
      end
      @testset "PuddleIgnoreAgent" begin
        pia = PuddleIgnoreAgent()
        @test pia.speed == 0.0
        @test pia.yaw_rate == 0.0
        @test pia.delta_time == 0.1
        @test pia.estimator === nothing
        @test pia.prev_spd == 0.0
        @test pia.prev_yr == 0.0
        @test pia.puddle_coef == 100
        @test pia.puddle_depth == 0.0
        @test pia.total_reward == 0.0
        @test pia.in_goal == false
        @test pia.final_value == 0.0
        @test pia.goal === nothing
        @test reward_per_sec(pia) == -1.0
      end
      @testset "DpPolicyAgent" begin
        dpa = DpPolicyAgent()
        @test dpa.speed == 0.0
        @test dpa.yaw_rate == 0.0
        @test dpa.delta_time == 0.1
        @test dpa.estimator === nothing
        @test dpa.prev_spd == 0.0
        @test dpa.prev_yr == 0.0
        @test dpa.puddle_coef == 100
        @test dpa.puddle_depth == 0.0
        @test dpa.total_reward == 0.0
        @test dpa.in_goal == false
        @test dpa.final_value == 0.0
        @test dpa.goal === nothing
        @test dpa.pose_min == [-4.0, -4.0, 0.0]
        @test dpa.pose_max == [4.0, 4.0, 2*pi]
        @test dpa.widths == [0.2, 0.2, pi/18]
        @test dpa.index_nums == round.(Int64, (dpa.pose_max - dpa.pose_min)./dpa.widths)
        @test reward_per_sec(dpa) == -1.0
        @test to_index(dpa, [3.0, 3.0, 0.0]) == [35, 35, 0]
        @test to_index(dpa, [5.0, 5.0, 0.0]) == [39, 39, 0]
        @test_nowarn draw_decision!(dpa, [])
      end
      @testset "Object" begin
        o = Object(1.0, 2.0, shape=:circle, color=:red, size=20, id=4)
        @test o.pose == [1.0, 2.0]
        @test o.id == 4
        @test o.size == 20
        @test o.color == :red
        @test o.shape == :circle
      end
      @testset "Map" begin
        m = Map()
        @test m.objects == []
        add_object(m, Object(1.0, 2.0))
        @test m.objects[1].pose == [1.0, 2.0]
      end
      @testset "Sensor" begin
        m = Map()
        add_object(m, Object(2.0, -2.0))
        s = Sensor(m)
        @test s.last_data == []
        @test s.dist_rng == (0.5, 6.0)
        @test s.dir_rng == (-pi/3, pi/3)
        @test visible(s, [0.5, -pi/3]) == true
        @test visible(s, [6.0, pi/3]) == true
        @test visible(s, [0.2, -pi/3]) == false
        @test visible(s, [0.5, pi]) == false
      end
      @testset "DifferentialWheeledRobot" begin
        a = Agent(0.1, 1.0)     
        r = DifferentialWheeledRobot([1, 1, 1], 0.5, "red", a, 0.1)
        @test r.pose == [1, 1, 1]
        @test r.radius == 0.5
        @test r.color == "red"
        @test r.delta_time == 0.1
        @test r.agent.speed == 0.1
        @test r.agent.yaw_rate == 1.0
      end
      @testset "Goal" begin
        g = Goal(1.0, 2.0, radius=0.5, value=1.0)
        @test g.pose[1] == 1.0
        @test g.pose[2] == 2.0
        @test g.radius == 0.5
        @test g.value == 1.0
        @test inside(g, [1.2, 2.0]) == true
        @test inside(g, [1.0, 3.0]) == false
        @test_nowarn draw!(g)
      end
      @testset "Puddle" begin
        p = Puddle([0.0, 0.0], [6.0, 6.0], 0.1)
        @test p.lower_left == [0.0, 0.0]
        @test p.upper_right == [6.0, 6.0]
        @test p.depth == 0.1
        @test_nowarn draw!(p)
        @test inside(p, [2.0, 2.0]) == true
        @test inside(p, [-1.0, -2.0]) == false
      end
      @testset "uncertainty" begin
        @testset "Movement" begin
          @testset "Kidnap" begin
            @test_nowarn AnimeMoveKidnap.main(is_test=true)
          end
          @testset "RandomNoise" begin
            @test_nowarn AnimeMoveRandomNoise.main(is_test=true)
          end
          @testset "SpeedBias" begin
            @test_nowarn AnimeMoveSpeedBias.main(is_test=true)
          end
          @testset "Stuck" begin
            @test_nowarn AnimeMoveStuck.main(is_test=true)
          end
        end
        @testset "Observation" begin
          @testset "Bias" begin
            @test_nowarn AnimeObserveBias.main(is_test=true)
          end
          @testset "Noise" begin
            @test_nowarn AnimeObserveNoise.main(is_test=true)
          end
          @testset "Occlusion" begin
            @test_nowarn AnimeObserveOcclusion.main(is_test=true)
          end
          @testset "Oversight" begin
            @test_nowarn AnimeObserveOversight.main(is_test=true)
          end
          @testset "Phantom" begin
            @test_nowarn AnimeObservePhantom.main(is_test=true)
          end
        end
      end
    end
  end
end