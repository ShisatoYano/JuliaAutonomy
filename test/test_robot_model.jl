# test module for robot_model

module TestRobotModel
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/movement/robot.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/movement/draw_robot.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/movement/agent.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/movement/draw_moving_robot.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/observation/landmark.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/observation/map.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/observation/draw_robot_landmark.jl"))

    function main()
        @testset "RobotModel" begin
            @testset "Movement" begin
                @testset "World" begin
                    world = World(-5.0, 5.0, -5.0, 5.0)
                    @test world.x_min == -5.0
                    @test world.x_max == 5.0
                    @test world.y_min == -5.0
                    @test world.y_max == 5.0
                    @test_nowarn draw(world)
                end
                @testset "Agent" begin
                    agent = Agent(0.1, 1.0)
                    speed, yaw_rate = decision(agent)
                    @test speed == 0.1
                    @test yaw_rate == 1.0
                end         
                @testset "Robot" begin
                    agent = Agent(0.1, 1.0)
                    robot = Robot([1, 1, 1], 0.5, "red", agent)
                    @test robot.pose == [1, 1, 1]
                    @test robot.radius == 0.5
                    @test robot.color == "red"
                    @test robot.agent.speed == 0.1
                    @test robot.agent.yaw_rate == 1.0
                    @test state_transition(0.1, 0.0, 1.0, [0, 0, 0]) == [0.1, 0.0, 0.0]
                    @test state_transition(0.1, 10.0/180*pi, 9.0, [0, 0, 0]) == [0.5729577951308232, 0.5729577951308231, 1.5707963267948966]
                    @test state_transition(0.1, 10.0/180*pi, 18.0, [0, 0, 0]) == [7.016709298534876e-17, 1.1459155902616465, 3.141592653589793]
                    @test_nowarn draw!(robot)
                end
                @testset "DrawRobot" begin
                    @test_nowarn DrawRobot.main()
                end
                @testset "DrawMovingRobot" begin
                    @test_nowarn DrawMovingRobot.main()
                end
            end
            @testset "Observation" begin
                @testset "Landmark" begin
                    lm = Landmark(1.0, 2.0)
                    @test lm.pose == [1.0, 2.0]
                    @test lm.id == -1
                    set_id(lm, 3)
                    @test lm.id == 3
                    @test_nowarn draw!(lm)
                end
                @testset "Map" begin
                    m = Map()
                    @test m.landmarks == []
                    add_landmark(m, Landmark(1.0, 2.0))
                    @test m.landmarks[1].pose == [1.0, 2.0]
                    @test_nowarn draw!(m)
                end
                @testset "DrawRobotLandmark" begin
                    @test_nowarn DrawRobotLandmark.main()
                end
            end
        end
    end
end