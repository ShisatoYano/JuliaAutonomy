# module for logging robot's trajectory and observation
# logged data is used for graph based slam simulation

module TrajObsrvLogger
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  function animate_per_time(time_interval, world, map, robot)
    draw(world)
    annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
    draw!(map)
    draw!(robot)
  end

  function main(time_interval=3.0; is_test=false)
    w = World(-5.0, 5.0, -5.0, 5.0)
    
    # create true map
    m = Map()
    landmark_positions = [[-4.0, 2.0],[2.0, -3.0],[3.0, 3.0],[0.0, 4.0], [1.0, 1.0], [-3.0, -1.0]]
    for (idx, pos) in enumerate(landmark_positions)
      add_object(m, Object(pos[1], pos[2], id=idx))
    end

    s = PsiSensor(m, dist_noise_rate=0.1, dir_noise=pi/90,
                  dist_bias_rate_stddev=0.1, dir_bias_stddev=pi/90)
    
    init_pose = [0.0, -3.0, 0.0]
    a = LoggerAgent(0.2, 5.0/180*pi, time_interval=time_interval, init_pose=init_pose)
    r = DifferentialWheeledRobot(init_pose, 0.2, "black",
                                 a, time_interval,
                                 noise_per_meter=5, 
                                 noise_std=pi/30,
                                 bias_rate_stds=[0.1, 0.1],
                                 sensor=s)
    
    if is_test == false
      anime = @animate for t in 0:time_interval:180
        animate_per_time(t, w, m, r)
      end
      path = "src/slam/graph_based_slam/traj_obsrv_edge_input_log.gif"
      gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
      close_log_file(a)
    else
      for t in 0:time_interval:90
        animate_per_time(t, w, m, r)
      end
    end
  end
end