# test module for bayes_theorem

module TestBayesTheorem
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/bayes_theorem/probs_bayes.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/bayes_theorem/bayes_estimation_630.jl"))

    function main()
        @testset "BayesTheorem" begin
            @testset "ProbsBayes" begin
                @test ProbsBayes.main() == true
            end
            @testset "BayesEst630" begin
                @test BayesEst630.main() == true
            end
        end
    end
end