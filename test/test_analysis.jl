# module for testing each analysis modules

module TestAnalysis
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/analysis/error_calculation/error_calculation.jl"))

  function main()
    @testset "Analysis" begin
      @testset "ErrorCalculation" begin
        error = calc_lon_lat_error([5.0, 5.0, 5.0], [0.0, 0.0, 0.0])
        @test error[1] == 5.00
        @test error[2] == 5.00
        @test error[3] == 5.00
      end
    end
  end
end