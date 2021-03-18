# test module for robot_model

module TestRobotModel
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/movement/robot.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/movement/draw_robot.jl"))

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
                @testset "Robot" begin
                    robot = Robot([1, 1, 1], 0.5, "red")
                    @test robot.pose == [1, 1, 1]
                    @test robot.radius == 0.5
                    @test robot.color == "red"
                    @test_nowarn draw!(robot)
                end
                @testset "DrawRobot" begin
                    @test_nowarn DrawRobot.main()
                end
            end
        end
    end
end