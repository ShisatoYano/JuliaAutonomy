# decision making simulation
# using augmented mdp(amdp)

module AnimeAmdp
  using Plots
  pyplot()

  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/puddle_world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/warp_robot/warp_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/localization/extended_kalman_filter/extended_kalman_filter.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/partially_observable_mdp/amdp_policy_agent.jl"))

  function main(delta_time=0.1, end_time=30; is_test=false)
    # save path of gif file
    path = "src/decision_making/partially_observable_mdp/anime_amdp.gif"

    # simulation world
    world = PuddleWorld(-5.0, 5.0, -5.0, 5.0,
                        delta_time=delta_time,
                        end_time=end_time,
                        is_test=is_test,
                        save_path=path)
    
    # map including landmarks 
    map = Map()
    for (id, lm) in enumerate([[1.0, 4.0], [4.0, 1.0], [-4.0, -4.0]])
      add_object(map, Object(lm[1], lm[2], id=id))
    end
    append(world, map)

    # puddles
    for puddle in [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1), Puddle([-0.5, -2.0], [2.5, 1.0], 0.1)]
      append(world, puddle)
    end

    # goal
    goal = Goal(-3.0, -3.0)
    append(world, goal)

    # robot including sensor, agent, estimator
    for init_pose in [[2.5, 2.5, pi]]
      sensor = Sensor(map, dist_noise_rate=0.1, dir_noise=pi/90)
      ekf = ExtendedKalmanFilter(init_pose, env_map=map,
                                 dist_dev_rate=0.14,
                                 dir_dev=0.05)
      agent = AmdpPolicyAgent(delta_time=delta_time, estimator=ekf, goal=goal)
      robot = DifferentialWheeledRobot(init_pose, 0.2, "red",
                                       agent, delta_time,
                                       noise_per_meter=5, 
                                       noise_std=pi/30,
                                       bias_rate_stds=[0.1, 0.1],
                                       sensor=sensor)
      append(world, robot)
    end
    
    draw(world)
  end
end