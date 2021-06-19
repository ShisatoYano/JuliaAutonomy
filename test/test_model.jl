# module for testing each model modules

module TestModel
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/agent/agent.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/map/map.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/object/object.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/sensor/sensor.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))
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