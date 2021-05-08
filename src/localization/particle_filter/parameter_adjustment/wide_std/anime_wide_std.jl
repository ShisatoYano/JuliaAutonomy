# module for checking wide particle movement
# using wide noise parameters

module AnimeWideStd
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  function animate_per_time(time_interval, world, robot)
    draw(world)
    annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
    draw!(robot)
  end

  function main(time_interval=0.1; is_test=false)
    w = World(-5.0, 5.0, -5.0, 5.0)

    s = Sensor(Map(), dist_noise_rate=0.1, dir_noise=pi/90,
               dist_bias_rate_stddev=0.1, dir_bias_stddev=pi/90)

    init_pose = [0.0, 0.0, 0.0]
    noises = Dict("nn"=>1, "no"=>2, "on"=>3, "oo"=>4)
    e = MclRandSamp(init_pose, 100, noises)
    circling = Agent(0.2, 10.0/180*pi, estimator=e)
    r = DifferentialWheeledRobot(init_pose, 0.2, "black",
                                 circling, time_interval,
                                 noise_per_meter=5, 
                                 noise_std=pi/30,
                                 bias_rate_stds=[0.1, 0.1],
                                 sensor=s)

    if is_test == false
      anime = @animate for t in 0:time_interval:30
        animate_per_time(t, w, r)
      end
      path = "src/localization/particle_filter/parameter_adjustment/wide_std/anime_wide_std.gif"
      gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
    else
      for t in 0:time_interval:10
        animate_per_time(t, w, r)
      end
    end
  end
end