# module for drawing moving robots
# add random noise against robot moving

module AnimeMoveRandomNoise
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  function animate_per_time(time_interval, world, noise_robot, 
                            no_noise_robot)
    draw(world)
    annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
    draw!(noise_robot)
    draw!(no_noise_robot)
  end

  function main(time_interval=0.1; is_test=false)
    w = World(-5.0, 5.0, -5.0, 5.0)
    
    init_pose = [0.0, 0.0, 0.0]
    circling = Agent(0.2, 10.0/180*pi)
    
    nr = DifferentialWheeledRobot(init_pose, 0.2, "gray",
                                  circling, time_interval,
                                  noise_per_meter=5, 
                                  noise_std=pi/30)

    nnr = DifferentialWheeledRobot(init_pose, 0.2, "red",
                                   circling, time_interval)

    if is_test == false
      anime = @animate for t in 0:time_interval:30
        animate_per_time(t, w, nr, nnr)
      end
      path = "src/model/uncertainty/movement/random_noise/anime_move_random_noise.gif"
      gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
    else
      for t in 0:time_interval:10
        animate_per_time(t, w, nr, nnr)
      end
    end
  end
end