# create dataframe of each group by hour
# calculate probability of each distance

module DfGroupHour
    using DataFrames, CSV, Statistics

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

        # dictionary
        each_hour = Dict([(string(i), sort(df, "lidar").lidar) for (i, df) in enumerate(df_grp)])

        # convert to dataframe
        freqs = DataFrame(each_hour)
        println(freqs)
    end
end