# plot probability distribution of sensor data
module ProbDist
    using DataFrames, CSV, Plots, FreqTables, NamedArrays

    function main()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df_200_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        tbl = freqtable(df_200_mm.lidar)
        freqs = [value for(name, value) in enumerate(tbl)]
        observs = [Int(obsv) for obsv in names(tbl, 1)]
        probs = freqs ./ length(df_200_mm.lidar)

        println("Observations: $(observs)")
        println("Probability: $(probs)")

        bar(probs, xticks=observs)

        save_path = joinpath(split(@__FILE__, "src")[1], "img/prob_dist.png")
        savefig(save_path)

        return true
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .ProbDist
    ProbDist.main()
end