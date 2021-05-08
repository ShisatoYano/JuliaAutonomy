# module for calculating standard deviation parameters
# robot moves for 4m at 0.1m/s on straight trajectory
# including random noise
# this is iterated for 100 times

module MotionTestForward
  using DataFrames, Statistics

  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))

  function main(time_interval=0.1)
    w = World(-5.0, 5.0, -5.0, 5.0)

    rs = []
    init_pose = [0.0, 0.0, 0.0]
    straight = Agent(0.1, 0.0)
    for i in 1:100
      r = DifferentialWheeledRobot(init_pose, 0.2, "black",
                                   straight, time_interval,
                                   noise_per_meter=5, 
                                   noise_std=pi/60)
      push!(rs, r)  
    end

    for t in 0:time_interval:40
      draw(w)
      annotate!(-3.5, 4.5, "t = $(time_interval)", "black")
      for r in rs
        draw!(r)
      end
    end

    poses = DataFrame(range=[sqrt(r.pose[1]^2 + r.pose[2]^2) for r in rs],
                      theta=[r.pose[3] for r in rs])
    theta_var = var(poses.theta, corrected=false)
    range_mean = mean(poses.range)
    println("Variance of range and theta: ", poses)
    println("Variance of theta: ", theta_var)
    println("Mean of range: ", range_mean)
    println("Standard deviation per m of theta: ", sqrt(theta_var/range_mean))
  end
end