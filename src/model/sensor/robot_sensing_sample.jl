# sample to show robot module's sensing
module RobotSensingSample
  # include external modules
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/puddle_world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/agent/agent.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/object/object.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/sensor/sensor.jl"))

  # main function
  # show world's graph
  function main(delta_time=0.1, end_time=30; is_test=false)
    # save path of output
    path = "src/model/sensor/robot_sensing_sample.gif"

    # world instance
    world = PuddleWorld(-5.0, 5.0, -5.0, 5.0,
                        delta_time=delta_time,
                        end_time=end_time,
                        is_test=is_test,
                        save_path=path)
    
    # map including landmarks
    map = Map()
    add_object(map, Object(2.0, -2.0, id=1))
    add_object(map, Object(-1.0, -3.0, id=2))
    add_object(map, Object(3.0, 3.0, id=3))
    append(world, map)
    
    # robot instance
    robot = DifferentialWheeledRobot([-2.0, -1.0, pi/5*6], 0.2, "black",
                                     Agent(0.2, 10.0/180*pi), delta_time,
                                     sensor=Sensor(map))
    append(world, robot)
    
    # draw graph
    draw(world)
  end
end