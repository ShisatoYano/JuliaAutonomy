# unit test suite of JuliaAutonomy

module TestSuite
  using Test

  # test modules
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_localization.jl"))
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_common.jl"))
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_model.jl"))
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_prob_stats.jl"))
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_slam.jl"))
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_decision_making.jl"))

  function main()
    TestCommon.main()
    TestLocalization.main()
    TestModel.main()
    TestProbStats.main()
    TestSlam.main()
    TestDecisionMaking.main()
  end
end

if abspath(PROGRAM_FILE) == @__FILE__
  using .TestSuite
  TestSuite.main()
end