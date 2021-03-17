# unit test suite of JuliaAutonomy

module TestSuite
    using Test

    # test modules
    include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_prob_stats.jl"))
    include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_robot_model.jl"))

    function main()
        TestProbStats.main()
        TestRobotModel.main()
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestSuite
    TestSuite.main()
end