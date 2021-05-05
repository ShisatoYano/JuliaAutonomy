# module for drawing monte carlo localization
# localized by particle filter
# parameter nn: range std on straight movement
# parameter no: range std on rotation movement
# parameter on: direction std on straight movement
# parameter oo: direction std on rotation movement

module DrawMcl
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/landmark.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_camera/real_camera.jl"))

  function main()
    # world coordinate system
    world = World(-5.0, 5.0, -5.0, 5.0)
    time_interval = 0.1 # [s]

    # generate map including landmarks
    map = Map()
    add_landmark(map, Landmark(-4.0, 2.0))
    add_landmark(map, Landmark(2.0, -3.0))
    add_landmark(map, Landmark(3.0, 3.0))

    # define sensor including random noise and bias
    cam = RealCamera(map, dist_noise_rate=0.1, dir_noise=pi/90,
                     dist_bias_rate_stddev=0.1, dir_bias_stddev=pi/90)

    # movement noise parameters
    # defined as dictionary
    noise_dict = Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20)

    # define robot
    initial_pose = [0.0, 0.0, 0.0]
    estimator_mcl = MonteCarloLocalization(initial_pose, 100, 
                                           noise_dict, env_map=map, 
                                           dist_dev_rate=0.14, 
                                           dir_dev=0.05)
    circling = Agent(0.2, 10.0/180*pi, estimator=estimator_mcl)
    robot = RealRobot(initial_pose, 0.2, "red",
                      circling, time_interval,
                      noise_per_meter=5, 
                      noise_std=pi/30,
                      bias_rate_stds=[0.1, 0.1],
                      camera=cam)
    
    # draw animation
    anim = @animate for t in 0:time_interval:30
      # world
      draw(world)

      # time
      annotate!(-3.5, 4.5, "t = $(t)", "black")

      # map
      draw!(map)

      # robot
      draw!(robot)
    end

    save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_mcl_sys_samp.gif")
    gif(anim, fps=15, save_path)
  end
end 