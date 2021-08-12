# decision making simulation
# using unreliable state estimation

module AnimeDpMcl
  using Plots
  pyplot()

  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/puddle_world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/warp_robot/warp_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/systematic_sampling/mcl_sys_samp.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/agent/dp_policy_agent.jl"))

  function main(delta_time=0.1, end_time=30; is_test=false)
    # save path of gif file
    path = "src/decision_making/partially_observable_mdp/anime_dp_mcl.gif"

    # simulation world
    world = PuddleWorld(-5.0, 5.0, -5.0, 5.0,
                        delta_time=delta_time,
                        end_time=end_time,
                        is_test=is_test,
                        save_path=path)
    
    # map including landmarks 
    map = Map()
    landmark_positions = [[1.0, 4.0],[4.0, 1.0],[-4.0, -4.0]]
    for (idx, pos) in enumerate(landmark_positions)
      add_object(map, Object(pos[1], pos[2], id=idx))
    end
    append(world, map)

    # goal
    goal = Goal(-3.0, -3.0)
    append(world, goal)

    # puddles
    append(world, Puddle([-2.0, 0.0], [0.0, 2.0], 0.1))
    append(world, Puddle([-0.5, -2.0], [2.5, 1.0], 0.1))

    # robot including sensor, agent, estimator
    init_pose = [2.5, 2.5, 0.0]
    sensor = Sensor(map, dist_noise_rate=0.1, dir_noise=pi/90)
    noises = Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20)
    mcl = MclSysSamp(init_pose, 100, noises, env_map=map,
                     dist_dev_rate=0.14, dir_dev=0.05)
    agent = DpPolicyAgent(delta_time=delta_time, estimator=mcl, goal=goal)
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