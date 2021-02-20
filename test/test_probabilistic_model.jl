# test module for probabilistic_model

module TestProbabilisticModel
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/probabilistic_model/gaussian_distribution.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/probabilistic_model/gauss_prob_dist.jl"))

    function main()
        @testset "ProbabilisticModel" begin
            @testset "GaussDistModel" begin
                @test GaussDistModel.p(190) == 2.064932530633184e-5
                @test GaussDistModel.p(210) == 0.08231272044708592
                @test GaussDistModel.p(230) == 1.2364903952298874e-5
                @test GaussDistModel.main() == true
            end
            @testset "GaussProbDist" begin
                @test GaussProbDist.prob(193) == 0.0002254354061377026
                @test GaussProbDist.prob(210) == 0.08187587024811953
                @test GaussProbDist.prob(229) == 3.113715670488921e-5
                @test GaussProbDist.main() == true
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestProbabilisticModel
    TestProbabilisticModel.main()
end