# print data/sensor_data_*.txt

module PrintSensorData
    using DataFrames, CSV

    function print_data_200()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df_200_mm = CSV.read(data_path, DataFrame, header=["date", "time", "ir", "lidar"])

        println("sensor_data_200.txt")
        println("Data size = ", size(df_200_mm))
        println("Column Names = ", names(df_200_mm))
        println("Data type = ", eltype.(eachcol(df_200_mm)))
        println("Describe = ", describe(df_200_mm))
        println("")

        return df_200_mm
    end

    function print_data_600()
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
        df_600_mm = CSV.read(data_path, DataFrame, header=["date", "time", "ir", "lidar"])

        println("sensor_data_600.txt")
        println("Data size = ", size(df_600_mm))
        println("Column Names = ", names(df_600_mm))
        println("Data type = ", eltype.(eachcol(df_600_mm)))
        println("Describe = ", describe(df_600_mm))
        println("")

        return df_600_mm
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .PrintSensorData
    PrintSensorData.print_data_200()
    PrintSensorData.print_data_600()
end