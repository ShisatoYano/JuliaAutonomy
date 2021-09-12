# sample to show robot module's movement
module RobotMoveSample
  # include external modules
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/puddle_world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/agent/agent.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  # main function
  # show world's graph
  function main(delta_time=0.1, end_time=20; is_test=false)
    # save path of output
    path = "src/model/robot/robot_move_sample.gif"

    # world instance
    world = PuddleWorld(-5.0, 5.0, -5.0, 5.0,
                        delta_time=delta_time,
                        end_time=end_time,
                        is_test=is_test,
                        save_path=path)
    
    # robot instance
    # straight movement
    straight = Agent(0.2, 0.0)
    robot1 = DifferentialWheeledRobot([2.0, 3.0, pi/6], 0.2, "black",
                                      straight, delta_time)
    append(world, robot1) # add in world
    # circling movement
    circling = Agent(0.2, 10.0/180*pi)
    robot2 = DifferentialWheeledRobot([-2.0, -1.0, pi/5*6], 0.2, "red",
                                      circling, delta_time)
    append(world, robot2) # add in world
    # staying
    staying = Agent(0.0, 0.0)
    robot3 = DifferentialWheeledRobot([0.0, 0.0, 0.0], 0.2, "blue",
                                      staying, delta_time)
    append(world, robot3) # add in world
    
    # draw graph
    draw(world)
  end
end