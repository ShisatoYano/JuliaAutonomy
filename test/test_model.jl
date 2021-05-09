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
        speed, yaw_rate = decision(a)
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
        @test observation_function([-2, -1, pi/5*6], [2.0, -2.0]) == [4.123105625617661, 2.2682954597449703]
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
        @test state_transition(0.1, 0.0, 1.0, [0, 0, 0]) == [0.1, 0.0, 0.0]
        @test state_transition(0.1, 10.0/180*pi, 9.0, [0, 0, 0]) == [0.5729577951308232, 0.5729577951308231, 1.5707963267948966]
        @test state_transition(0.1, 10.0/180*pi, 18.0, [0, 0, 0]) == [7.016709298534876e-17, 1.1459155902616465, 3.141592653589793]
      end
    end
  end
end