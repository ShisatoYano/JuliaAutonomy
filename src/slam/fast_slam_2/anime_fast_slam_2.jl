# module for playing mapping and localization by fast slam 2.0
# particles are resampled by random sampling

module AnimeFastSlam2
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/slam/fast_slam_2/fast_slam_2.jl"))

  function animate_per_time(time_interval, world, map, robot)
    draw(world)
    annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
    draw!(map)
    draw!(robot)
  end

  function main(time_interval=0.1; is_test=false)
    w = World(-5.0, 5.0, -5.0, 5.0)
    
    m = Map()
    add_object(m, Object(-4.0, 2.0, id=1))
    add_object(m, Object(2.0, -3.0, id=2))
    add_object(m, Object(3.0, 3.0, id=3))
    add_object(m, Object(4.0, 0.0, id=4))
    add_object(m, Object(-2.0, 4.0, id=5))
    add_object(m, Object(-3.0, -3.0, id=6))

    s = Sensor(m, dist_noise_rate=0.1, dir_noise=pi/90,
               dist_bias_rate_stddev=0.1, dir_bias_stddev=pi/90)
    
    init_pose = [0.0, 0.0, 0.0]
    e = FastSlam2(init_pose, objects_num=length(m.objects))
    circling = FastSlam2Agent(0.2, 10.0/180*pi, estimator=e)
    r = DifferentialWheeledRobot(init_pose, 0.2, "black",
                                 circling, time_interval,
                                 noise_per_meter=5, 
                                 noise_std=pi/30,
                                 bias_rate_stds=[0.1, 0.1],
                                 sensor=s)
    
    if is_test == false
      anime = @animate for t in 0:time_interval:30
        animate_per_time(t, w, m, r)
      end
      path = "src/slam/fast_slam_2/anime_fast_slam_2.gif"
      gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
    else
      for t in 0:time_interval:10
        animate_per_time(t, w, m, r)
      end
    end
  end
end