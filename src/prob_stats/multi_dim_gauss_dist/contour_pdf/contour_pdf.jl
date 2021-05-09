# calculate probability by pdf
# plot as 2d-contour

module ContourPdf
    using DataFrames, CSV, Statistics, LinearAlgebra
    using Base.Iterators, Plots
    pyplot()

    function pdf(x, mu, cov_mat)
        # determinant
        det_mat = det(cov_mat)

        diff_x = x - mu
        return exp(-((diff_x'/cov_mat)*diff_x)/2)/(2*pi*sqrt(det_mat))
    end

    function main(is_test=false)
        # input
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_700.txt")
        df_org = CSV.read(data_path, DataFrame, 
                      header=["date", "time", "ir", "lidar"],
                      delim=' ')
        
        # extract between 12 and 16 o'clock
        df_ext = df_org[(df_org.time.>=120000).&(df_org.time.<160000),:]

        # variance
        var_ir = var(df_ext.ir)
        var_lidar = var(df_ext.lidar)

        #covariance
        diff_ir = df_ext.ir .- mean(df_ext.ir)
        diff_lidar = df_ext.lidar .- mean(df_ext.lidar)
        a = diff_ir .* diff_lidar
        covar = cov(df_ext.ir, df_ext.lidar, corrected=false)
        
        # covariance matrix
        cov_mat = [var_ir covar; covar var_lidar]

        # mean(mu)
        mu = [mean(df_ext.ir); mean(df_ext.lidar)]

        # plot contour
        vx = 0:40
        vy = 710:750
        z = [pdf([x; y], mu, cov_mat) for x in vx, y in vy]
        contour(z', label="contour", c=:haline, xlabel="x", 
                ylabel="y", aspect_ratio=:equal)
        
        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/multi_dim_gauss_dist/contour_pdf/contour_pdf.png")
            savefig(save_path)
        end
    end
end