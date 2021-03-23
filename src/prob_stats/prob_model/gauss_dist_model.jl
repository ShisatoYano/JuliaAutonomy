# plot gaussian distribution model

module GaussDistModel
    using Plots
    pyplot()

    function p(z, mu=209.7, dev=23.4)
        return exp(-(z - mu)^2 / (2 * dev)) / sqrt(2 * pi * dev)
    end

    function main()
        zs = Array(190:230)
        ys = [p(z) for z in zs]

        println("Observations: $(zs)")
        println("Probability: $(ys)")

        plot(zs, ys, label="gaussian distribution")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/gauss_dist_model.png")
        savefig(save_path)
    end
end