# create dataframe of each group by hour
# plot kernek density estimation

module MarginalKde
    using DataFrames, CSV, FreqTables
    using Plots, StatsPlots
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
        
        # plot marginal kde
        marginalkde(df_new.hour, df_new.lidar, c=:ice, 
                    xlabel="Hour", ylabel="LiDAR")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/marginal_kde.png")
        savefig(save_path)

        return true
    end
end