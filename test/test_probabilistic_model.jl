# test module for probabilistic_model

module TestProbabilisticModel
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/probabilistic_model/gaussian_distribution.jl"))

    function main()
        @testset "ProbabilisticModel" begin
            @testset "GaussDistModel" begin
                @test GaussDistModel.main() == true
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestProbabilisticModel
    TestProbabilisticModel.main()
end