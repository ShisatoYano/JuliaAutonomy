# create dataframe of each group by hour
# calculate probability of each distance

module GrpHrHeatmap
    using DataFrames, CSV, FreqTables, Plots
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
        pivot = freqtable(df_new, :lidar, :hour)
        println(pivot)

        #heatmap
        x = names(pivot, 2)
        y = names(pivot, 1)
        freqs = [value for(name, value) in enumerate(pivot)]
        probs = freqs ./ length(df_org.lidar)
        heatmap(x, y, probs)
        
        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/complex_dist/group_hour_heatmap/group_hour_heatmap.png")
            savefig(save_path)
        end
    end
end