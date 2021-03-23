# plot gaussian probabilistic distribution

module GaussProbDist
    using DataFrames, CSV, Plots, FreqTables, NamedArrays
    pyplot()

    function p(z, mu=209.7, dev=23.4)
        return exp(-(z - mu)^2 / (2 * dev)) / sqrt(2 * pi * dev)
    end

    function prob(z, width=0.5)
        return width * (p(z - width) + p(z + width))
    end

    function main()
        # probability from observations
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df_200_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        tbl = freqtable(df_200_mm.lidar)
        freqs = [value for(name, value) in enumerate(tbl)]
        observs = [Int(obsv) for obsv in names(tbl, 1)]
        probs = freqs ./ length(df_200_mm.lidar)

        # probability from model
        zs = Array(193:229)
        ys = [prob(z) for z in zs]

        println("Dummy Observations: $(zs)")
        println("Probability from model: $(ys)")

        bar(ys, xticks=zs, color=:red, alpha=0.3, label="Model")
        bar!(probs, xticks=observs, color=:blue, alpha=0.3, label="Observations")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/gauss_prob_dist.png")
        savefig(save_path)
    end
end