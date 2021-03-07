# calculate probability by pdf
# sensor_data_200.txt
# plot as 2d-contour

module ContourPdf200
    using DataFrames, CSV, Statistics, LinearAlgebra
    using Base.Iterators, Plots
    pyplot()

    function pdf(x, mu, cov_mat)
        # inverse matrix
        inv_mat = inv(cov_mat)

        # determinant
        det_mat = det(cov_mat)

        diff_x = x - mu
        return exp(-((diff_x'/cov_mat)*diff_x)/2)/(2*pi*sqrt(det_mat))
    end

    function main()
        # input
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df = CSV.read(data_path, DataFrame, 
                      header=["date", "time", "ir", "lidar"],
                      delim=' ')

        # variance
        var_ir = var(df.ir)
        var_lidar = var(df.lidar)

        #covariance
        diff_ir = df.ir .- mean(df.ir)
        diff_lidar = df.lidar .- mean(df.lidar)
        a = diff_ir .* diff_lidar
        covar = cov(df.ir, df.lidar, corrected=false)
        
        # covariance matrix
        cov_mat = [var_ir covar; covar var_lidar]

        # mean(mu)
        mu = [mean(df.ir); mean(df.lidar)]

        # plot contour
        vx = 280:340
        vy = 180:240
        z = map(product(vx, vy)) do (x, y)
            pdf([x; y], mu, cov_mat)
        end
        contour(vx, vy, z, label="Probability Density", c=:haline)

        save_path = joinpath(split(@__FILE__, "src")[1], "img/contour_pdf_200.png")
        savefig(save_path)

        return true
    end
end