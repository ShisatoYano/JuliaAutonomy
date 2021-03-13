# plot kernek density estimation

module MarginalKde200
    using DataFrames, CSV, StatsPlots
    pyplot()

    function main()
        # input
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df = CSV.read(data_path, DataFrame, 
                      header=["date", "time", "ir", "lidar"],
                      delim=' ')

        # plot marginal kde
        marginalkde(df.ir, df.lidar, c=:ice, 
                    xlabel="ir", ylabel="liDAR")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/marginal_kde_200.png")
        savefig(save_path)

        return true
    end
end