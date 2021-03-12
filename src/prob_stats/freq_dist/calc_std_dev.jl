# calculate standard deviation of sensor data

module CalcStdDev
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

        sampling_std_dev = sqrt(sampling_var)
        unbiased_std_dev = sqrt(unbiased_var)

        # calculate by Statistics
        stats_std_dev = Statistics.std(zs, corrected=false)

        println("Sampling standard deviation = $sampling_std_dev")
        println("Unbiased standard deviation = $unbiased_std_dev")
        println("Standard deviation by Statistics = $stats_std_dev")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .CalcStdDev
    CalcStdDev.main()
end