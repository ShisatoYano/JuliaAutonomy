# calculate sum of probability at each lidar's data

module ProbSumLidar
    using DataFrames, CSV, Plots, FreqTables
    pyplot()

    function main(is_test=false)
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
        df_org = CSV.read(data_path, DataFrame, 
                      header=["date", "time", "ir", "lidar"],
                      delim=' ')
        
        hours = [Int64(floor(e/10000)) for e in df_org.time]

        # add hour array to df
        df_h = DataFrame(hour=hours)
        df_new = hcat(df_org, df_h)

        # pivot
        freqs = freqtable(df_new, :hour, :lidar)
        probs = freqs / length(df_org.lidar)

        # sum
        keys = names(probs, 2)
        probs_sum = [sum(probs[begin:end, Name(key)]) for key in keys]
        plot(keys, probs_sum, label="Probability")
        println("Sum of probability = $(round(sum(probs)))")
        
        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/complex_dist/prob_sum_lidar/prob_sum_lidar.png")
            savefig(save_path)
        end

        return round(sum(probs))
    end
end