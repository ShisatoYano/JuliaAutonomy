module TestDecisionMaking
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/markov_decision_process/policy_evaluator.jl"))

  function main()
    @testset "PolicyEvaluator" begin
      pe = PolicyEvaluator([0.2, 0.2, pi/18])
      @test pe.pose_min == [-4.0, -4.0, 0.0]
      @test pe.pose_max == [4.0, 4.0, 2*pi]
      @test pe.widths == [0.2, 0.2, pi/18]
      @test pe.index_nums == [40, 40, 36]
    end
  end
end