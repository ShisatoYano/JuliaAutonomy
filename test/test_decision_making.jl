module TestDecisionMaking
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/markov_decision_process/policy_evaluator.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/goal/goal.jl"))

  function main()
    @testset "PolicyEvaluator" begin
      g = Goal(4.0, 4.0)
      pe = PolicyEvaluator([0.2, 0.2, pi/18], g)
      @test pe.pose_min == [-4.0, -4.0, 0.0]
      @test pe.pose_max == [4.0, 4.0, 2*pi]
      @test pe.widths == [0.2, 0.2, pi/18]
      @test pe.goal == g
      @test pe.index_nums == (41, 41, 37)
      nx, ny, nt = pe.index_nums[1], pe.index_nums[2], pe.index_nums[3]
      @test pe.indexes == vec(collect(Base.product(1:nx, 1:ny, 1:nt)))
      @test get_index(pe, [-4.0, -4.0, 0.0]) == [1, 1, 1]
      @test get_index(pe, [4.0, 4.0, 0.0]) == [41, 41, 1]
      @test get_index(pe, [2.9, -2.0, pi]) == [35, 11, 19]
      @test final_state(pe, (40, 40, 37)) == true
      @test final_state(pe, (1, 1, 1)) == false
    end
  end
end