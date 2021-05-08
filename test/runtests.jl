# unit test suite of JuliaAutonomy

module TestSuite
  using Test

  # test modules
  include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_localization.jl"))

  function main()
    TestLocalization.main()
  end
end

if abspath(PROGRAM_FILE) == @__FILE__
  using .TestSuite
  TestSuite.main()
end