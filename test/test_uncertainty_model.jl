# test module for uncertainty_model

module TestUncertaintyModel
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/move_random_noise/move_random_noise.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/move_kidnap/move_kidnap.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/move_speed_bias/move_speed_bias.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/move_stuck/move_stuck.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/observe_bias/observe_bias.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/observe_noise/observe_noise.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/observe_occlusion/observe_occlusion.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/observe_oversight/observe_oversight.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/observe_phantom/observe_phantom.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/real_camera/real_camera.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/uncertainty_model/real_robot/real_robot.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/robot_model/observation/map.jl"))

    function main()
        @testset "UncertaintyModel" begin
            @testset "RealCamera" begin
                cam = RealCamera(Map(),
                                 dist_noise_rate=0.1,
                                 dir_noise=0.1,
                                 dist_bias_rate_stddev=0.1,
                                 dir_bias_stddev=0.1,
                                 phantom_prob=0.1,
                                 oversight_prob=0.1,
                                 occlusion_prob=0.1)
                @test cam.dist_rng == (0.5, 6.0)
                @test cam.dir_rng == (-pi/3, pi/3)
                @test cam.dist_noise_rate == 0.1
                @test cam.dir_noise == 0.1
                @test cam.phantom_prob == 0.1
                @test cam.oversight_prob == 0.1
                @test cam.occlusion_prob == 0.1
            end
            @testset "RealRobot" begin
                robot = RealRobot([0.0, 0.0, 0.0], 0.2, "black",
                                  Agent(0.2, 10.0/180*pi), 0.1)
                @test robot.camera == nothing
                @test robot.is_stuck == false
                @test robot.pose == [0.0, 0.0, 0.0]
                @test robot.radius == 0.2
                @test robot.color == "black"
                @test robot.delta_time == 0.1
                @test robot.traj_x[1] == 0.0
                @test robot.traj_y[1] == 0.0
            end
            @testset "MoveRandomNoise" begin
                @test_nowarn MoveRandomNoise.main()
            end
            @testset "MoveKidnap" begin
                @test_nowarn MoveKidnap.main()
            end
            @testset "MoveSpeedBias" begin
                @test_nowarn MoveSpeedBias.main()
            end
            @testset "MoveStuck" begin
                @test_nowarn MoveStuck.main()
            end
            @testset "ObserveBias" begin
                @test_nowarn ObserveBias.main()
            end
            @testset "ObserveNoise" begin
                @test_nowarn ObserveNoise.main()
            end
            @testset "ObserveOcclusion" begin
                @test_nowarn ObserveOcclusion.main()
            end
            @testset "ObserveOversight" begin
                @test_nowarn ObserveOversight.main()
            end
            @testset "ObservePhantom" begin
                @test_nowarn ObservePhantom.main()
            end
        end
    end
end