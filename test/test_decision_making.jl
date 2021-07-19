module TestDecisionMaking
  using Test

  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/decision_making/markov_decision_process/policy_evaluator.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/model/puddle/puddle.jl"))

  function main()
    @testset "PolicyEvaluator" begin
      g = Goal(4.0, 4.0)
      pd = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1)]
      pe = PolicyEvaluator([0.2, 0.2, pi/18], g, pd, 0.1, 10)
      @test pe.pose_min == [-4.0, -4.0, 0.0]
      @test pe.pose_max == [4.0, 4.0, 2*pi]
      @test pe.widths == [0.2, 0.2, pi/18]
      @test pe.goal == g
      @test pe.index_nums == [40, 40, 36]
      nx, ny, nt = pe.index_nums[1], pe.index_nums[2], pe.index_nums[3]
      @test pe.indexes == vec(collect(Base.product(0:nx-1, 0:ny-1, 0:nt-1)))
      @test get_index(pe, [-4.0, -4.0, 0.0]) == [0, 0, 0]
      @test get_index(pe, [4.0, 4.0, 0.0]) == [40, 40, 0]
      @test get_index(pe, [2.9, -2.0, pi]) == [34, 10, 18]
      @test final_state(pe, (40, 40, 37)) == true
      @test final_state(pe, (1, 1, 1)) == false
      @test out_correction(pe, [1, 1, 40]) == [1, 1, 4]
    end
  end
end