# draw histogram of sensor data 600

module DrawHist600
    using Plots, DataFrames, CSV

    function main()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
        df_600_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        bin_min_max = maximum(df_600_mm.lidar) - minimum(df_600_mm.lidar)
        histogram(df_600_mm.lidar, bins=bin_min_max, label="histogram")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/histogram_600_mm.png")
        savefig(save_path)

        return true
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .DrawHist600
    DrawHist600.main()
end