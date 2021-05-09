# plot gaussian distribution model

module GaussDistModel
    using Plots
    pyplot()

    function p(z, mu=209.7, dev=23.4)
        return exp(-(z - mu)^2 / (2 * dev)) / sqrt(2 * pi * dev)
    end

    function main(is_test=false)
        zs = Array(190:230)
        ys = [p(z) for z in zs]

        println("Observations: $(zs)")
        println("Probability: $(ys)")

        plot(zs, ys, label="gaussian distribution")

        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/prob_model/gauss_dist_model/gauss_dist_model.png")
            savefig(save_path)
        end
    end
end