# unit test suite of JuliaAutonomy

module TestSuite
  using Test

  # test modules
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_localization.jl"))
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_analysis.jl"))
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_model.jl"))
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_prob_stats.jl"))

  function main()
    TestAnalysis.main()
    TestLocalization.main()
    TestModel.main()
    TestProbStats.main()
  end
end

if abspath(PROGRAM_FILE) == @__FILE__
  using .TestSuite
  TestSuite.main()
end