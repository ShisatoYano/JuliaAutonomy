# test module for error_ellipse

module TestErrorEllipse
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/error_ellipse/multiple_gauss_dist.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/error_ellipse/calc_plot_eigen.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/error_ellipse/calc_cov_mat.jl"))

    function main()
        @testset "ErrorEllipse" begin
            @testset "MultiGaussDist" begin
                @test MultiGaussDist.main() == true
            end
            @testset "CalcPlotEigen" begin
                @test CalcPlotEigen.main() == true
            end
            @testset "CalcCovMat" begin
                @test CalcCovMat.main() == true
            end
        end
    end
end