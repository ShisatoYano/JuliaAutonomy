# calculate covariance

module CalcCovariance
    using DataFrames, CSV, Statistics

    function main()
        # input
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_700.txt")
        df_org = CSV.read(data_path, DataFrame, 
                      header=["date", "time", "ir", "lidar"],
                      delim=' ')
        
        # extract between 12 and 16 o'clock
        df_ext = df_org[(df_org.time.>=120000).&(df_org.time.<160000),:]

        # calculate
        println("Variance of ir: $(var(df_ext.ir))")
        println("Variance of lidar: $(var(df_ext.lidar))")
        
        diff_ir = df_ext.ir .- mean(df_ext.ir)
        diff_lidar = df_ext.lidar .- mean(df_ext.lidar)
        
        a = diff_ir .* diff_lidar
        println("Covariance: $(sum(a)/size(df_ext)[1])")
    end
end