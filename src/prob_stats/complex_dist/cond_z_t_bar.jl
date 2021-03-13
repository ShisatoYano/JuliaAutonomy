# calculate P(z|t)
# P(z|t) = P(z,t) / P(t)

module CondZtBar
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
        keys = names(probs, 2)
        probs_t = [sum(probs[begin:end, Name(key)]) for key in keys]

        # P(z|t)
        cond_z_t = probs / probs_t[1] # P(t=0)
        z = names(probs, 1)
        println(cond_z_t)

        # bar plot
        bar(cond_z_t[begin:end, Name(6)], xticks=z, alpha=0.3, color=:blue, label="Hour:6")
        bar!(cond_z_t[begin:end, Name(14)], xticks=z, alpha=0.3, color=:red, label="Hour:14")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/cond_z_t.png")
        savefig(save_path)

        return true
    end
end