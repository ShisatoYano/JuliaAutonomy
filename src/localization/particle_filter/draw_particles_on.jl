# module for drawing particles
# those particles are used for particle filter
# add std parameter for only direction on straight course

module DrawParticlesOn
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))

  function main()
    # world coordinate system
    world = World(-5.0, 5.0, -5.0, 5.0)

    time_interval = 0.1

    # robot
    initial_pose = [0.0, 0.0, 0.0]
    estimator_mcl = MonteCarloLocalization(initial_pose, 100, Dict("nn"=>0.001, "no"=>0.001, "on"=>0.11, "oo"=>0.001))
    straight = Agent(0.1, 0.0, estimator=estimator_mcl)
    robot = RealRobot(initial_pose, 0.2, "black", straight, 
                      time_interval, noise_per_meter=5, 
                      noise_std=pi/60)
    
    # draw animation
    anim = @animate for t in 0:time_interval:40
      # world
      draw(world)

      # time
      annotate!(-3.5, 4.5, "t = $(t)", "black")

      # robot
      draw!(robot)
    end

    save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_particles_on.gif")
    gif(anim, fps=15, save_path)
  end
end