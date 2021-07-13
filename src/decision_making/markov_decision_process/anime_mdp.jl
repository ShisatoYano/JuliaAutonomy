# Path planning simulation by dynamic programming
# problem as markov decision precess

module AnimeMdp
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/localization/extended_kalman_filter/extended_kalman_filter.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))

  function animate_per_time(time_interval, world, map, robot, goal, puddle1, puddle2)
    draw(world)
    annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
    draw!(map)
    draw!(robot)
    draw!(goal)
    draw!(puddle1)
    draw!(puddle2)
  end

  function main(time_interval=0.1; is_test=false)
    w = World(-5.0, 5.0, -5.0, 5.0)

    m = Map()
    landmark_positions = [[-4.0, 2.0],[2.0, -3.0],[3.0, 3.0]]
    for (idx, pos) in enumerate(landmark_positions)
      add_object(m, Object(pos[1], pos[2], id=idx))
    end
    g = Goal(-3.0, -3.0)

    s = Sensor(m, dist_noise_rate=0.1, dir_noise=pi/90)
    
    init_pose = [0.0, 0.0, 0.0]
    ekf = ExtendedKalmanFilter(init_pose, env_map=m,
                               dist_dev_rate=0.14,
                               dir_dev=0.05)
    a = Agent(0.2, 10.0/180*pi, estimator=ekf)
    r = DifferentialWheeledRobot(init_pose, 0.2, "red",
                                 a, time_interval,
                                 noise_per_meter=5, 
                                 noise_std=pi/30,
                                 bias_rate_stds=[0.1, 0.1],
                                 sensor=s)
  
    p1 = Puddle([-2.0, 0.0], [0.0, 2.0], 0.1)
    p2 = Puddle([-0.5, -2.0], [2.5, 1.0], 0.1)
    
    if is_test == false
      anime = @animate for t in 0:time_interval:30
        animate_per_time(t, w, m, r, g, p1, p2)
      end
      path = "src/decision_making/markov_decision_process/anime_mdp.gif"
      gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
    else
      for t in 0:time_interval:10
        animate_per_time(t, w, m, r, g)
      end
    end
  end
end