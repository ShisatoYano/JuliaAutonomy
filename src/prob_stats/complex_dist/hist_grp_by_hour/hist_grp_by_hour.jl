# draw histogram of lidar's sensing data grouped by hour

module HistGrpByHour
    using Plots, DataFrames, CSV, Statistics
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

        # sort
        df_sort = sort(df_new, "hour")

        # grouping
        df_grp = groupby(df_sort, "hour")

        # histogram
        df_grp_6 = df_grp[6]
        df_grp_14 = df_grp[14]
        histogram(df_grp_6.lidar, color=:blue, label="6")
        histogram!(df_grp_14.lidar, color=:orange, label="14")

        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/complex_dist/hist_grp_by_hour/hist_grp_by_hour.png")
            savefig(save_path)
        end
    end
end