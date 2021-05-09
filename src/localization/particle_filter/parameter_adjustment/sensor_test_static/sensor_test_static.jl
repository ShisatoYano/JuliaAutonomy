# module for calculating std of sensor observation
# observe a landmark by a sensor
# iterate for 1000 times

module SensorTestStatic
  using DataFrames, Statistics

  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  function main()
    m = Map()
    add_object(m, Object(1.0, 0.0))
    
    distances = []
    directions = []

    for i in 1:1000
      s = Sensor(m, dist_noise_rate=0.1,
                 dir_noise=pi/90, dist_bias_rate_stddev=0.1,
                 dir_bias_stddev=pi/90)
      data(s, [0.0, 0.0, 0.0])
      if length(s.last_data) > 0
        push!(distances, s.last_data[1][1][1])
        push!(directions, s.last_data[1][1][2])
      end
    end

    df = DataFrame(distance=distances, direction=directions)
    println("Observation data: ", df)
    println("standard deviation of distance: ", std(df.distance, corrected=false))
    println("standard deviation of direction: ", std(df.direction, corrected=false))
  end
end