# module for testing each common modules

module TestCommon
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/common/covariance_ellipse/covariance_ellipse.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/common/error_calculation/error_calculation.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/common/state_transition/state_transition.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/common/observation_function/observation_function.jl"))

  function main()
    @testset "Common" begin
      @testset "CovarianceEllipse" begin
        @test_nowarn draw_covariance_ellipse!([0.0, 0.0, 0.0],
                                              [1.0 0.0 0.0;
                                               0.0 1.0 0.0;
                                               0.0 0.0 1.0], 3)
      end
      @testset "ErrorCalculation" begin
        error = calc_lon_lat_error([5.0, 5.0, 5.0], [0.0, 0.0, 0.0])
        @test error[1] == 5.00
        @test error[2] == 5.00
        @test error[3] == 5.00
      end
      @testset "StateTransition" begin
        @test state_transition(0.1, 0.0, 1.0, [0, 0, 0]) == [0.1, 0.0, 0.0]
        @test state_transition(0.1, 10.0/180*pi, 9.0, [0, 0, 0]) == [0.5729577951308232, 0.5729577951308231, 1.5707963267948966]
        @test state_transition(0.1, 10.0/180*pi, 18.0, [0, 0, 0]) == [7.016709298534876e-17, 1.1459155902616465, 3.141592653589793]
      end
      @testset "ObservationFunction" begin
        @test observation_function([-2, -1, pi/5*6], [2.0, -2.0]) == [4.123105625617661, 2.2682954597449703]
      end
    end
  end
end