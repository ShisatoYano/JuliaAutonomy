# unit test suite of JuliaAutonomy

module TestSuite
    using Test

    # test modules
    include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_sensor_data.jl"))
    include(joinpath(split(@__FILE__, "runtests.jl")[1], "test_probabilistic_model.jl"))

    function main()
        TestSensorData.main()
        TestProbabilisticModel.main()
    end
end