# create dataframe of each group by hour
# calculate sum of probability at each hour

module ProbSumHour
    using DataFrames, CSV, Plots, FreqTables
    pyplot()

    function main()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
        df_org = CSV.read(data_path, DataFrame, 
                      header=["date", "time", "ir", "lidar"],
                      delim=' ')
        
        hours = [Int64(floor(e/10000)) for e in df_org.time]

        # add hour array to df
        df_h = DataFrame(hour=hours)
        df_new = hcat(df_org, df_h)

        # pivot
        freqs = freqtable(df_new, :lidar, :hour)
        probs = freqs / length(df_org.lidar)

        # sum
        probs_sum = [sum(probs[begin:end, i]) for i in Array(1:24)]
        plot(Array(0:23), probs_sum, label="Probability")
        println("Sum of probability = $(sum(probs))")
        
        save_path = joinpath(split(@__FILE__, "src")[1], "img/prob_sum.png")
        savefig(save_path)

        return sum(probs)
    end
end