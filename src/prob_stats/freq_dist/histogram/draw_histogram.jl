# draw histgram of sensor data

module DrawHistogram
    using Plots, DataFrames, CSV
    pyplot()

    function main(is_test=false)
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df_200_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        bin_min_max = maximum(df_200_mm.lidar) - minimum(df_200_mm.lidar)
        histogram(df_200_mm.lidar, bins=bin_min_max, label="histogram")

        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/freq_dist/histogram/histogram_200_mm.png")
            savefig(save_path)
        end
    end
end