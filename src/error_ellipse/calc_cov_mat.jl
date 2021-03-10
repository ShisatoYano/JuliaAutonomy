# calculate covariance matrix
# from eigen values and vectors

module CalcCovMat
    using LinearAlgebra

    function main()
        # x-y grid
        vx = 0:200
        vy = 0:100

        # mu, covariance matrix
        mu = [150; 50]
        cov = [100 -25*sqrt(3); -25*sqrt(3) 50]

        # calculate eigen values/vectors
        eig_vals, eig_vecs = eigen(cov)
        V = eig_vecs
        L = [eig_vals[1] 0; 0 eig_vals[2]]

        # calculate covariance matrix
        cov_mat_calc = V * L * inv(V)
        println("Calculated Covariance Matrix: $(cov_mat_calc)")
        println("Original Covariance Matrix: $(cov)")

        return true
    end
end