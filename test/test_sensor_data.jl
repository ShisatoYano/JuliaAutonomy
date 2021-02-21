# test module for sensor_data

module TestSensorData
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/print_sensor_data.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/draw_histogram.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/histogram_mean.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/calc_variance.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/calc_std_dev.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/prob_dist.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/draw_hist_600.jl"))

    function main()
        @testset "SensorData" begin
            @testset "PrintSensorData" begin
                @test_nowarn PrintSensorData.print_data_200()
                @test_nowarn PrintSensorData.print_data_600()
            end
            @testset "DrawHistogram" begin
                @test DrawHistogram.main() == true
            end
            @testset "HistogramMean" begin
                @test HistogramMean.main() == true
            end
            @testset "CalcVariance" begin
                @test_nowarn CalcVariance.main()
            end
            @testset "CalcStdDev" begin
                @test_nowarn CalcStdDev.main()
            end
            @testset "ProbDist" begin
                @test ProbDist.main() == true
            end
            @testset "DrawHist600" begin
                @test DrawHist600.main() == true
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestSensorData
    TestSensorData.main()
end