# decision making simulation
# using probabilistic flow control

module AnimePfc
  using Plots
  pyplot()

  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/puddle_world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/warp_robot/warp_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/localization/reset_process/sensor_reset_mcl/sensor_reset_mcl.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/partially_observable_mdp/pfc_agent.jl"))

  function main(delta_time=0.1, end_time=30; is_test=false)
    # save path of gif file
    path = "src/decision_making/partially_observable_mdp/anime_pfc.gif"

    # simulation world
    world = PuddleWorld(-5.0, 5.0, -5.0, 5.0,
                        delta_time=delta_time,
                        end_time=end_time,
                        is_test=is_test,
                        save_path=path)
    
    # map including landmarks 
    map = Map()
    add_object(map, Object(0.0, 0.0, id=1))
    append(world, map)

    # goal
    goal = Goal(-1.5, -1.5)
    append(world, goal)

    # robot including sensor, agent, estimator
    init_pose = [3.5, 3.5, pi]
    sensor = Sensor(map, dist_noise_rate=0.1, dir_noise=pi/90)
    mcl = SensorResetMcl(init_pose, 100, env_map=map)
    agent = PfcAgent(delta_time=delta_time, estimator=mcl, goal=goal, puddles=[])
    robot = DifferentialWheeledRobot(init_pose, 0.2, "red",
                                     agent, delta_time,
                                     noise_per_meter=5, 
                                     noise_std=pi/30,
                                     bias_rate_stds=[0.1, 0.1],
                                     sensor=sensor)
    append(world, robot)
    
    draw(world)
  end
end