# draw histogram of sensor data 600 as time series

module DrawTimeSeries600
    using Plots, DataFrames, CSV
    pyplot()

    function main(is_test=false)
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
        df_600_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        time_idx = Array(0:length(df_600_mm.lidar)-1)

        plot(time_idx, df_600_mm.lidar, lebel="time series")

        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/complex_dist/time_series_600mm/time_series_600_mm.png")
            savefig(save_path)
        end
    end
end