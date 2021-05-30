# module for playing monte carlo localization by particle filter
# particles are resampled by random sampling
# global localization simulation

module AnimeGlobalMcl
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  function animate_per_time(time_interval, world, map, robot)
    draw(world)
    annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
    draw!(map)
    draw!(robot)
  end

  function main(time_interval=0.1; particle_num=100, is_test=false)
    w = World(-5.0, 5.0, -5.0, 5.0)
    
    m = Map()
    add_object(m, Object(-4.0, 2.0, id=1))
    add_object(m, Object(2.0, -3.0, id=2))
    add_object(m, Object(3.0, 3.0, id=3))

    s = Sensor(m, dist_noise_rate=0.1, dir_noise=pi/90,
               dist_bias_rate_stddev=0.1, dir_bias_stddev=pi/90)
    
    init_pose = [rand(Uniform(-5.0, 5.0)), rand(Uniform(-5.0, 5.0)), rand(Uniform(-pi, pi))]
    e = GlobalMcl(particle_num, env_map=m)
    circling = Agent(0.2, 10.0/180*pi, estimator=e)
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
      path = "src/localization/particle_filter/global_mcl/anime_global_mcl.gif"
      gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
      return true
    else
      for t in 0:time_interval:30
        animate_per_time(t, w, m, r)
      end
      actual = r.pose
      est = r.agent.estimator.estimated_pose
      error = sqrt((actual[1] - est[1])^2 + (actual[2] - est[2])^2)
      println("Particle:$(particle_num), Actual:$(actual), Est:$(est), Error:$(error)")
      if error <= 1.0
        return true
      else
        return false
      end
    end
  end
end