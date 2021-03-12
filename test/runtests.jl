# unit test suite of JuliaAutonomy

module TestSuite
    using Test

    # test modules
    include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_prob_stats.jl"))
    include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_bayes_theorem.jl"))
    include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_covariance.jl"))
    include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_error_ellipse.jl"))

    function main()
        TestProbStats.main()
        TestBayesTheorem.main()
        TestCovariance.main()
        TestErrorEllipse.main()
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestSuite
    TestSuite.main()
end