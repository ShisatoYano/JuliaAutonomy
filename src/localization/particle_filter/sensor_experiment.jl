# module for calculating std of sensor observation
# observe a landmark by a sensor
# iterate for 1000 times

module SensorExperiment
  using DataFrames, Statistics

  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/landmark.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_camera/real_camera.jl"))

  function main()
    # generate map including landmarks
    map = Map()
    add_landmark(map, Landmark(1.0, 0.0))

    # observation list for storing
    distances = []
    directions = []

    for i in 1:1000
      camera = RealCamera(map, dist_noise_rate=0.1,
                          dir_noise=pi/90, dist_bias_rate_stddev=0.1,
                          dir_bias_stddev=pi/90)
      data(camera, [0.0, 0.0, 0.0])
      if length(camera.last_data) > 0
        push!(distances, camera.last_data[1][1][1])
        push!(directions, camera.last_data[1][1][2])
      end
    end

    # caluculate standard deviation
    df = DataFrame(distance=distances, direction=directions)
    println("Observation data: ", df)
    println("standard deviation of distance: ", std(df.distance, corrected=false))
    println("standard deviation of direction: ", std(df.direction, corrected=false))
  end
end