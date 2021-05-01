# module for calculating variance parameters
# robot moves for 4m at 0.1m/s on straight trajectory
# this is iterated for 100 times

module MotionTestForward
  using DataFrames, Statistics

  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))

  function main()
    # world coordinate system
    world = World(-5.0, 5.0, -5.0, 5.0)

    time_interval = 0.1 # [s]

    # robots
    robots = []
    initial_pose = [0.0, 0.0, 0.0]
    straight = Agent(0.1, 0.0)
    for i in 1:100
      robot = RealRobot(initial_pose, 0.2, "black", straight, 
                        time_interval, noise_per_meter=5,
                        noise_std=pi/60)
      push!(robots, robot)  
    end
    
    # draw animation
    anim = @animate for t in 0:time_interval:40
      # world
      draw(world)

      # time
      annotate!(-3.5, 4.5, "t = $(t)", "black")

      # robot
      for r in robots
        draw!(r)  
      end
    end

    save_path = joinpath(split(@__FILE__, "src")[1], "gif/motion_test_forward.gif")
    gif(anim, fps=15, save_path)

    # calculate variance after moved
    poses = DataFrame(
                      range=[sqrt(r.pose[1]^2 + r.pose[2]^2) for r in robots],
                      theta=[r.pose[3] for r in robots])
    theta_var = var(poses.theta, corrected=false)
    range_mean = mean(poses.range)
    println("Variance of range and theta: ", poses)
    println("Variance of theta: ", theta_var)
    println("Mean of range: ", range_mean)
    println("Standard deviation per m of theta: ", sqrt(theta_var/range_mean))
  end
end