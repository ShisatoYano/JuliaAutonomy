# plot lidar's sensing data grouped by hour

module GroupByHour
    using Plots, DataFrames, CSV, Statistics
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

        # sort
        df_sort = sort(df_new, "hour")

        # grouping
        df_grp = groupby(df_sort, "hour")
        
        # mean by group
        grps = Array(0:23)
        ovsbs = [mean(grp.lidar) for grp in df_grp]
        plot(grps, ovsbs, label="observation")
        
        save_path = joinpath(split(@__FILE__, "src")[1], "img/group_by_hour.png")
        savefig(save_path)

        return true
    end
end