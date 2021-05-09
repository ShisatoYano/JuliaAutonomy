# plot gaussian probabilistic distribution
# using cumulative distribution function

module GaussProbDistCdf
    using Plots, Distributions
    pyplot()

    function main(is_test=false)
        norm_dist = Normal(209.7, 4.84) # mu, std_dev

        zs = Array(193:229)
        ys = [cdf(norm_dist, z) for z in zs]
        plot(zs, ys, color=:red, label="CDF")

        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/prob_model/gauss_prob_dist_cdf/gauss_prob_dist_cdf.png")
            savefig(save_path)
        end
    end
end