# test module for bayesian/variational_inference

module TestInference
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/bayesian_inference/gauss_gamma.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/variational_inference/categorical_distribution.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/variational_inference/dirichlet_distribution.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/variational_inference/variational_inference.jl"))

  function main()
    @testset "BayesianInference" begin
      @testset "GaussGamma" begin
        @test_nowarn GaussGamma.main(test=true)
      end
    end
    @testset "VariationalInference" begin
      @testset "CategoricalDistribution" begin
        @test_nowarn CategoricalDistribution.main()
      end
      @testset "DirichletDistribution" begin
        @test_nowarn DirichletDistribution.main()
      end
      @testset "VariationalInference" begin
        @test_nowarn VariationalInference.main(test=true)
      end
    end
  end
end