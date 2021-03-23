# test module for prob_stats

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
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/draw_hist_600.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/draw_time_series_600.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/group_by_hour.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/hist_grp_by_hour.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/group_hour_heatmap.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/prob_sum_hour.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/prob_sum_lidar.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/cond_z_t_bar.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/probs_bayes.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/bayes_estimation_630.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/bayes_est_at_5.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/complex_dist/bayes_est_at_11.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/multi_dim_gauss_dist/calc_covariance.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/multi_dim_gauss_dist/contour_pdf.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/multi_dim_gauss_dist/contour_pdf_plus20.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/multi_dim_gauss_dist/contour_pdf_200.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/multi_dim_gauss_dist/multiple_gauss_dist.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/multi_dim_gauss_dist/calc_plot_eigen.jl"))
    include(joinpath(split(@__FILE__, "test")[1], "src/prob_stats/multi_dim_gauss_dist/calc_cov_mat.jl"))

    function main()
        @testset "ProbStats" begin
            @testset "SensorData" begin
                @test_nowarn PrintSensorData.print_data_200()
                @test_nowarn PrintSensorData.print_data_600()
            end
            @testset "FreqDist" begin
                @test DrawHistogram.main() == true
                @test_nowarn HistogramMean.main()
                @test_nowarn CalcVariance.main()
                @test_nowarn CalcStdDev.main()
            end
            @testset "ProbDist" begin
                @test_nowarn ProbDist.main()
            end
            @testset "ProbModel" begin
                @testset "GaussDistModel" begin
                    @test GaussDistModel.p(190) == 2.064932530633184e-5
                    @test GaussDistModel.p(210) == 0.08231272044708592
                    @test GaussDistModel.p(230) == 1.2364903952298874e-5
                    @test_nowarn GaussDistModel.main()
                end
                @testset "GaussProbDist" begin
                    @test GaussProbDist.prob(193) == 0.0002254354061377026
                    @test GaussProbDist.prob(210) == 0.08187587024811953
                    @test GaussProbDist.prob(229) == 3.113715670488921e-5
                    @test_nowarn GaussProbDist.main()
                end
                @testset "GaussProbDistPdf" begin
                    @test_nowarn GaussProbDistPdf.main()
                end
                @testset "GaussProbDistCdf" begin
                    @test_nowarn GaussProbDistCdf.main()
                end
                @testset "BarProbDistCdf" begin
                    @test_nowarn BarProbDistCdf.main()
                end
                @testset "CalcExpValue" begin
                    @test_nowarn CalcExpValue.main()
                end    
            end
            @testset "ComplexDist" begin
                @testset "DrawHist600" begin
                    @test_nowarn DrawHist600.main()
                end
                @testset "DrawTimeSeries600" begin
                    @test_nowarn DrawTimeSeries600.main()
                end
                @testset "GroupByHour" begin
                    @test_nowarn GroupByHour.main()
                end
                @testset "HistGrpByHour" begin
                    @test_nowarn HistGrpByHour.main()
                end
                @testset "GrpHrHeatmap" begin
                    @test_nowarn GrpHrHeatmap.main()
                end
                @testset "ProbSumHour" begin
                    @test ProbSumHour.main() == 1.0
                end
                @testset "ProbSumLidar" begin
                    @test ProbSumLidar.main() == 1.0
                end
                @testset "CondZtBar" begin
                    @test_nowarn CondZtBar.main()
                end
                @testset "ProbsBayes" begin
                    @test_nowarn ProbsBayes.main()
                end
                @testset "BayesEst630" begin
                    @test_nowarn BayesEst630.main()
                end
                @testset "BayesEstAt5" begin
                    @test_nowarn BayesEstAt5.main()
                end
                @testset "BayesEstAt11" begin
                    @test_nowarn BayesEstAt11.main()
                end    
            end
            @testset "MultiDimGuassDist" begin
                @testset "CalcCovariance" begin
                    @test_nowarn CalcCovariance.main()
                end
                @testset "ContourPdf" begin
                    @test ContourPdf.main() == true
                end
                @testset "ContourPdfPlus20" begin
                    @test_nowarn ContourPdfPlus20.main()
                end
                @testset "ContourPdf200" begin
                    @test_nowarn ContourPdf200.main()
                end
                @testset "MultiGaussDist" begin
                    @test_nowarn MultiGaussDist.main()
                end
                @testset "CalcPlotEigen" begin
                    @test_nowarn CalcPlotEigen.main()
                end
                @testset "CalcCovMat" begin
                    @test_nowarn CalcCovMat.main()
                end
            end
        end
    end
end