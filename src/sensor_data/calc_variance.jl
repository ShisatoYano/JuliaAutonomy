# calculate varianve of sensor data

module CalcVariance
    using DataFrames, CSV, Statistics

    function main()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df_200_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        # calculate from definition
        zs = df_200_mm.lidar # observation
        mean_def = sum(zs) / length(zs) # mean
        diff_square = [(z - mean_def)^2 for z in zs]
        
        sampling_var = sum(diff_square) / length(zs) # sampling variance
        unbiased_var = sum(diff_square) / (length(zs) - 1) # unbiased variance

        println("Sampling Variance = $sampling_var")
        println("Unbiased Variance = $unbiased_var")

        # calculate by Statistics
        stats_sampling_var = Statistics.var(zs, corrected=false)
        stats_unbiased_var = Statistics.var(zs, corrected=true)

        println("Sampling Variance by Statistics = $stats_sampling_var")
        println("Unbiased Variance by Statistics = $stats_unbiased_var")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .CalcVariance
    CalcVariance.main()
end