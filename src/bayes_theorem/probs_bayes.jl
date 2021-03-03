# calculate probability by bayes theorem

module ProbsBayes
    using DataFrames, CSV, FreqTables

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
        println("P(t) = $(p_t)")

        # P(z)
        probs_trans = transpose(probs)
        keys_trans = names(probs_trans, 2)
        p_z = [sum(probs_trans[begin:end, Name(key)]) for key in keys_trans]
        println("P(z) = $(p_z)")

        # P(t|z)
        for (i, key) in enumerate(keys_trans)
            probs_trans[begin:end, Name(key)] /= p_z[i]
        end
        cond_t_z = probs_trans

        p_z_630 = p_z[findfirst(keys_trans .== 630)]
        p_t_13 = p_t[findfirst(keys .== 13)]
        p_t_13_z_630 = cond_t_z[Name(13), Name(630)]

        bayes = p_t_13_z_630 * p_z_630 /p_t_13

        cond_z_t = probs / p_t[findfirst(keys .== 13)]
        answer = cond_z_t[Name(630), Name(13)]
        
        println("P(z=630) = $(p_z_630)")
        println("P(t=13) = $(p_t_13)")
        println("P(t=13|z=630) = $(p_t_13_z_630)")
        println("Bayes P(z=630|t=13) = $(bayes)")
        println("Answer P(z=630|t=13) = $(answer)")

        return true
    end
end