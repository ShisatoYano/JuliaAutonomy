# test module for bayes_theorem

module TestBayesTheorem
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/bayes_theorem/probs_bayes.jl"))

    function main()
        @testset "BayesTheorem" begin
            @testset "ProbsBayes" begin
                @test ProbsBayes.main() == true
            end
        end
    end
end