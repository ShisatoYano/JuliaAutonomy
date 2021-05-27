# module for testing each localization modules

module TestLocalization
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/particle/particle.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/random_sampling/anime_mcl_rand_samp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/systematic_sampling/anime_mcl_sys_samp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/kld_sampling/particle_num_kld.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/motion_test_forward/motion_test_forward.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/motion_test_forward_bias/motion_test_forward_bias.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/motion_test_rot_bias/motion_test_rot_bias.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/sensor_test_static/sensor_test_static.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/extended_kalman_filter/anime_ekf.jl"))

  function main()
    @testset "ParticleFilter" begin
      @testset "Particle" begin
        p = Particle([0.0, 0.0, 0.0], 0.0)
        @test p.pose[1] == 0.0
        @test p.pose[2] == 0.0
        @test p.pose[3] == 0.0
        @test p.weight == 0.0
      end
      @testset "RandomSampling" begin
        @test_nowarn AnimeMclRandSamp.main(is_test=true)
      end
      @testset "SystematicSampling" begin
        @test_nowarn AnimeMclSysSamp.main(is_test=true)
      end
      @testset "KldSampling" begin
        @testset "ParticleNumKld" begin
          @test_nowarn ParticleNumKld.main(true)
        end
      end
      @testset "ParameterAdjustment" begin
        @testset "MotionTestForward" begin
          @test_nowarn MotionTestForward.main()
        end
        @testset "MotionTestForwardBias" begin
          @test_nowarn MotionTestForwardBias.main()
        end
        @testset "MotionTestRotBias" begin
          @test_nowarn MotionTestRotBias.main()
        end
        @testset "SensorTestStatic" begin
          @test_nowarn SensorTestStatic.main()
        end
      end
    end
    @testset "KalmanFilter" begin
      @testset "ExtendedKalmanFilter" begin
        @test_nowarn AnimeEkf.main(is_test=true)  
      end
    end
  end
end