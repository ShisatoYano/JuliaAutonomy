# module for testing each localization modules

module TestLocalization
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/particle/particle.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/random_sampling/anime_mcl_rand_samp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/systematic_sampling/anime_mcl_sys_samp.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/narrow_std/anime_narrow_std.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/localization/particle_filter/parameter_adjustment/wide_std/anime_wide_std.jl"))

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
      @testset "ParameterAdjustment" begin
        
      end
    end
  end
end