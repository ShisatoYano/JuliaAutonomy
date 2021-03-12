# plot gaussian probabilistic distribution
# using probability density function

module GaussProbDistPdf
    using Plots, Distributions
    pyplot()

    function main()
        norm_dist = Normal(209.7, 4.84) # mu, std_dev

        zs = Array(193:229)
        ys = [pdf(norm_dist, z) for z in zs]
        plot(zs, ys, label="PDF")

        save_path = joinpath(split(@__FILE__, "src")[1], "img/gauss_prob_dist_pdf.png")
        savefig(save_path)

        return true
    end
end