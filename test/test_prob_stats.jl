# test module for sensor_data

module TestProbStats
    using Test

    # target modules
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/sensor_data/print_sensor_data.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/freq_dist/draw_histogram.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/freq_dist/histogram_mean.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/freq_dist/calc_variance.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/freq_dist/calc_std_dev.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/prob_dist/prob_dist.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/prob_model/gauss_dist_model.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/prob_model/gauss_prob_dist.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/prob_model/gauss_prob_dist_pdf.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/prob_model/gauss_prob_dist_cdf.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/prob_model/bar_prob_dist_cdf.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/prob_model/calc_expected_value.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/draw_hist_600.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/draw_time_series_600.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/group_by_hour.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/hist_grp_by_hour.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/group_hour_heatmap.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/marginal_kde.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/prob_sum_hour.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/prob_sum_lidar.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/sensor_data/cond_z_t_bar.jl"))

    function main()
        @testset "ProbStats" begin
            @testset "SensorData" begin
                @test_nowarn PrintSensorData.print_data_200()
                @test_nowarn PrintSensorData.print_data_600()
            end
            @testset "FreqDist" begin
                @test DrawHistogram.main() == true
                @test HistogramMean.main() == true
                @test_nowarn CalcVariance.main()
                @test_nowarn CalcStdDev.main()
            end
            @testset "ProbDist" begin
                @test ProbDist.main() == true
            end
            @testset "ProbModel" begin
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
                @testset "GaussProbDistPdf" begin
                    @test GaussProbDistPdf.main() == true
                end
                @testset "GaussProbDistCdf" begin
                    @test GaussProbDistCdf.main() == true
                end
                @testset "BarProbDistCdf" begin
                    @test BarProbDistCdf.main() == true
                end
                @testset "CalcExpValue" begin
                    @test_nowarn CalcExpValue.main()
                end    
            end
            @testset "DrawHist600" begin
                @test DrawHist600.main() == true
            end
            @testset "DrawTimeSeries600" begin
                @test DrawTimeSeries600.main() == true
            end
            @testset "GroupByHour" begin
                @test GroupByHour.main() == true
            end
            @testset "HistGrpByHour" begin
                @test HistGrpByHour.main() == true
            end
            @testset "GrpHrHeatmap" begin
                @test GrpHrHeatmap.main() == true
            end
            # @testset "MarginalKde" begin
            #     @test MarginalKde.main() == true
            # end
            @testset "ProbSumHour" begin
                @test ProbSumHour.main() == 1.0
            end
            @testset "ProbSumLidar" begin
                @test ProbSumLidar.main() == 1.0
            end
            @testset "CondZtBar" begin
                @test CondZtBar.main() == true
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestSensorData
    TestSensorData.main()
end