# test module for error_ellipse

module TestErrorEllipse
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/error_ellipse/multiple_gauss_dist.jl"))

    function main()
        @testset "ErrorEllipse" begin
            @testset "MultiGaussDist" begin
                @test MultiGaussDist.main() == true
            end
        end
    end
end