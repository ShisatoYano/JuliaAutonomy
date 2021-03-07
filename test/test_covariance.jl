# test module for bayes_theorem

module TestCovariance
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/covariance/calc_covariance.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/covariance/contour_pdf.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/covariance/contour_pdf_plus20.jl"))

    function main()
        @testset "Covariance" begin
            @testset "CalcCovariance" begin
                @test_nowarn CalcCovariance.main()
            end
            @testset "ContourPdf" begin
                @test ContourPdf.main() == true
            end
            @testset "ContourPdfPlus20" begin
                @test ContourPdfPlus20.main() == true
            end
        end
    end
end