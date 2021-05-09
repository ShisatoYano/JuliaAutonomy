# module for drawing moving robots
# add bias error of movement speed

module AnimeMoveSpeedBias
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  function animate_per_time(time_interval, world, bias_robot, 
                            no_bias_robot)
    draw(world)
    annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
    draw!(bias_robot)
    draw!(no_bias_robot)
  end

  function main(time_interval=0.1; is_test=false)
    w = World(-5.0, 5.0, -5.0, 5.0)
    
    init_pose = [0.0, 0.0, 0.0]
    circling = Agent(0.2, 10.0/180*pi)
    
    br = DifferentialWheeledRobot(init_pose, 0.2, "gray",
                                  circling, time_interval,
                                  bias_rate_stds=[0.2, 0.2])

    nbr = DifferentialWheeledRobot(init_pose, 0.2, "red",
                                   circling, time_interval,
                                   bias_rate_stds=[0.0, 0.0])

    if is_test == false
      anime = @animate for t in 0:time_interval:30
        animate_per_time(t, w, br, nbr)
      end
      path = "src/model/uncertainty/movement/speed_bias/anime_move_speed_bias.gif"
      gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
    else
      for t in 0:time_interval:10
        animate_per_time(t, w, br, nbr)
      end
    end
  end
end