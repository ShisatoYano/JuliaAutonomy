# draw histogram of sensor data 600 as time series

module DrawTimeSeries600
    using Plots, DataFrames, CSV

    function main()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
        df_600_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        time_idx = Array(0:length(df_600_mm.lidar)-1)

        plot(time_idx, df_600_mm.lidar, lebel="time series")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/time_series_600_mm.png")
        savefig(save_path)

        return true
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .DrawTimeSeries600
    DrawTimeSeries600.main()
end