# module for testing each localization modules

module TestLocalization
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/particle/particle.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/random_sampling/anime_mcl_rand_samp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/systematic_sampling/anime_mcl_sys_samp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/kld_sampling/particle_num_kld.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/kld_sampling/particle_num_wh.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/kld_sampling/anime_kld_mcl.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/motion_test_forward/motion_test_forward.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/motion_test_forward_bias/motion_test_forward_bias.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/motion_test_rot_bias/motion_test_rot_bias.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/sensor_test_static/sensor_test_static.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/extended_kalman_filter/anime_ekf.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/global_localization/test_global_kf.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/global_localization/test_global_mcl.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/global_localization/test_global_kld_mcl.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/reset_process/random_reset_mcl/anime_random_reset_mcl.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/reset_process/sensor_reset_mcl/anime_sensor_reset_mcl.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/reset_process/adaptive_reset_mcl/anime_adaptive_reset_mcl.jl"))  

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
        @testset "ParticleNumWh" begin
          @test ParticleNumWh.num(0.1, 0.01, 2) == 34.0
          @test ParticleNumWh.num_wh(0.1, 0.01, 2) == 33.0
          @test_nowarn ParticleNumWh.main()
        end
        @testset "KldMcl" begin
          @test_nowarn AnimeKldMcl.main(is_test=true)
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
    @testset "GlobalLocalization" begin
      @testset "GlobalKf" begin
        @test_nowarn TestGlobalKf.main(5)
      end
      @testset "GlobalMcl" begin
        @test_nowarn TestGlobalMcl.main(5)
      end
      @testset "GlobalKldMcl" begin
        @test_nowarn TestGlobalKldMcl.main(5)
      end
    end
    @testset "ResetProcess" begin
      @testset "RandomResetMcl" begin
        @test_nowarn AnimeRandomResetMcl.main(is_test=true)
      end
      @testset "SensorResetMcl" begin
        @test_nowarn AnimeSensorResetMcl.main(is_test=true)
      end
      @testset "AdaptiveResetMcl" begin
        @test_nowarn AnimeAdaptiveResetMcl.main(is_test=true)
      end
    end
  end
end