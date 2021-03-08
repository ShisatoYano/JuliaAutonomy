# calculate eigen values/vectors
# plot eigen vectors on the contour

module CalcPlotEigen
    using Plots, Base.Iterators, LinearAlgebra
    pyplot()

    function pdf(x, mu, cov_mat)
        # determinant
        det_mat = det(cov_mat)

        diff_x = x - mu
        return exp(-((diff_x'/cov_mat)*diff_x)/2)/(2*pi*sqrt(det_mat))
    end

    function main()
        # x-y grid
        vx = 0:200
        vy = 0:100

        # mu, covariance matrix
        mu = [150; 50]
        cov = [100 -25*sqrt(3); -25*sqrt(3) 50]

        # calculate eigen values/vectors
        eig_vals, eig_vecs = eigen(cov)
        println("Eigen Values: $(eig_vals)")
        println("Eigen Vectors: $(eig_vecs)")
        println("Eigen Vector1: $(eig_vecs[:, 1])")
        println("Eigen Vector2: $(eig_vecs[:, 2])")

        # plot
        z = [pdf([x; y], mu, cov) for x in vx, y in vy]
        contour(z, label="contour", c=:haline, xlabel="x", ylabel="y")
        v1 = 2 * sqrt(eig_vals[1]) * eig_vecs[:, 1]
        v2 = 2 * sqrt(eig_vals[2]) * eig_vecs[:, 2]
        save_path = joinpath(split(@__FILE__, "src")[1], "img/contour_eigen.png")
        savefig(save_path)

        return true
    end
end