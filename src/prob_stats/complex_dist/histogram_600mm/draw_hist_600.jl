# draw histogram of sensor data 600

module DrawHist600
    using Plots, DataFrames, CSV
    pyplot()

    function main(is_test=false)
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
        df_600_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        bin_min_max = maximum(df_600_mm.lidar) - minimum(df_600_mm.lidar)
        histogram(df_600_mm.lidar, bins=bin_min_max, label="histogram")

        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/complex_dist/histogram_600mm/histogram_600_mm.png")
            savefig(save_path)
        end
    end
end