# module for drawing particles
# those particles are used for particle filter
# parameter nn: range std on straight movement
# parameter no: range std on rotation movement
# parameter on: direction std on straight movement
# parameter oo: direction std on rotation movement

module DrawParticlesWide
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/landmark.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_camera/real_camera.jl"))

  function main()
    # world coordinate system
    world = World(-5.0, 5.0, -5.0, 5.0)

    time_interval = 0.1

    # generate map including landmarks
    map = Map()

    # define robot
    initial_pose = [0.0, 0.0, 0.0]
    estimator_mcl = MonteCarloLocalization(initial_pose, 10, Dict("nn"=>1, "no"=>2, "on"=>3, "oo"=>4))
    circling = Agent(0.2, 10.0/180*pi, estimator=estimator_mcl)
    robot = RealRobot(initial_pose, 0.2, "black",
                      circling, time_interval,
                      noise_per_meter=5, 
                      noise_std=pi/30, 
                      camera=RealCamera(map))
    
    # draw animation
    anim = @animate for t in 0:time_interval:30
      # world
      draw(world)

      # time
      annotate!(-3.5, 4.5, "t = $(t)", "black")

      # robot
      draw!(robot)
    end

    save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_particles_wide.gif")
    gif(anim, fps=15, save_path)
  end
end