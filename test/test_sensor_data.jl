# test module for sensor_data

module TestSensorData
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/print_sensor_data.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/draw_histogram.jl"))

    function main()
        @testset "SensorData" begin
            @testset "PrintSensorData" begin
                @test_nowarn PrintSensorData.print_data_200()
                @test_nowarn PrintSensorData.print_data_600()
            end
            @testset "DrawHistogram" begin
                @test DrawHistogram.main() == true
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestSensorData
    TestSensorData.main()
end