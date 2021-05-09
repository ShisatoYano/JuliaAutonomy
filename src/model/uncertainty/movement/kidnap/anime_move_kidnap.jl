# module for drawing moving robots
# one of them move normally and the others sometimes are kidnapped

module AnimeMoveKidnap
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  function animate_per_time(time_interval, world, kidnapped_robot, 
                            no_kidnapped_robot)
    draw(world)
    annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
    draw!(kidnapped_robot)
    draw!(no_kidnapped_robot)
  end

  function main(time_interval=0.1; is_test=false)
    w = World(-5.0, 5.0, -5.0, 5.0)
    
    init_pose = [0.0, 0.0, 0.0]
    circling = Agent(0.2, 10.0/180*pi)
    
    kr = DifferentialWheeledRobot(init_pose, 0.2, "gray",
                                  circling, time_interval,
                                  exp_kidnap_time=3.0,
                                  kidnap_rx=[-5.0, 5.0],
                                  kidnap_ry=[-5.0, 5.0])

    nkr = DifferentialWheeledRobot(init_pose, 0.2, "red",
                                   circling, time_interval)

    if is_test == false
      anime = @animate for t in 0:time_interval:30
        animate_per_time(t, w, kr, nkr)
      end
      path = "src/model/uncertainty/movement/kidnap/anime_move_kidnap.gif"
      gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
    else
      for t in 0:time_interval:10
        animate_per_time(t, w, kr, nkr)
      end
    end
  end
end