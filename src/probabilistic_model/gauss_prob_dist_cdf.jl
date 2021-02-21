# plot gaussian probabilistic distribution
# using cumulative distribution function

module GaussProbDistCdf
    using Plots, Distributions

    function main()
        norm_dist = Normal(209.7, 4.84) # mu, std_dev

        plot(norm_dist, func=cdf, color=:red, label="CDF")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/gauss_prob_dist_cdf.png")
        savefig(save_path)

        return true
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .GaussProbDistCdf
    GaussProbDistCdf.main()
end