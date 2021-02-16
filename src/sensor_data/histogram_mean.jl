# draw histgram of sensor data

module DrawHistogram
    using Plots, DataFrames, CSV, Statistics

    function main()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df_200_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        a = sum(df_200_mm.lidar)
        println("Sum of sensor data = $a")

        b = length(df_200_mm.lidar)
        println("Length of sensor data = $b")

        mean_1 = a / b
        mean_2 = mean(df_200_mm.lidar)
        println("Mean(Sum / Length) = $mean_1")
        println("Mean(mean()) = $mean_2")
        
        bin_min_max = maximum(df_200_mm.lidar) - minimum(df_200_mm.lidar)
        histogram(df_200_mm.lidar, bins=bin_min_max, color=:orange)
        plot!([mean_1], st=:vline, color=:red, 
              ylim=(0, 5000), linewidth=5)

        save_path = joinpath(split(@__FILE__, "src")[1], "img/histogram_mean.png")
        savefig(save_path)

        return true
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .DrawHistogram
    DrawHistogram.main()
end