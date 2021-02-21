# plot probabilistic distribution as bar graph
# using cumulative distribution function

module BarProbDistCdf
    using Plots, Distributions

    function main()
        norm_dist = Normal(209.7, 4.84) # mu, std_dev

        zs = Array(190:230)
        ys = [cdf(norm_dist, z+0.5) - cdf(norm_dist, z-0.5) for z in zs]

        bar(ys, xtick=zs, label="Prob Dist")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/bar_prob_dist_cdf.png")
        savefig(save_path)

        return true
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .BarProbDistCdf
    BarProbDistCdf.main()
end