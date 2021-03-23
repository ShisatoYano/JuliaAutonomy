# estimate observed time by bayes theorem
# multiple observation at 5 o'clock

module BayesEstAt5
    using DataFrames, CSV, FreqTables, Plots

    function bayes_estimation(sensor_value, cond_z_t, current_estimation)
        new_estimation = zeros(24)
        for i in Array(1:24)
            new_estimation[i] = cond_z_t[Name(sensor_value), Name(i - 1)] * current_estimation[i]
        end
        return new_estimation / sum(new_estimation)
    end

    function main()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
        df_org = CSV.read(data_path, DataFrame, 
                      header=["date", "time", "ir", "lidar"],
                      delim=' ')
        
        hours = [Int64(floor(e/10000)) for e in df_org.time]

        # add hour array to df
        df_h = DataFrame(hour=hours)
        df_new = hcat(df_org, df_h)

        # P(t)
        freqs = freqtable(df_new, :lidar, :hour)
        probs = freqs / length(df_org.lidar)
        keys = names(probs, 2)
        p_t = [sum(probs[begin:end, Name(key)]) for key in keys]
        cond_z_t = probs / p_t[findfirst(==(0), keys)]

        # estimate
        observations_5 = [630, 632, 636]
        estimation = p_t
        for observ in observations_5
            estimation = bayes_estimation(observ, cond_z_t, estimation)
        end
        plot(estimation, label="P(t=5|z=630,632,636)")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/bayes_est_at_5.png")
        savefig(save_path)
    end
end