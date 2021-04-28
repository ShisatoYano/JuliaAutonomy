# module for drawing particles
# those particles are used for particle filter

module DrawParticles
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/landmark.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_camera/real_camera.jl"))

  function main()
    # world coordinate system
    world = World(-5.0, 5.0, -5.0, 5.0)

    # sampling time
    delta_t = 0.1

    # generate map including landmarks
    map = Map()
    add_landmark(map, Landmark(-4.0, 2.0))
    add_landmark(map, Landmark(2.0, -3.0))
    add_landmark(map, Landmark(3.0, 3.0))

    # define robot
    initial_pose = [2.0, 2.0, pi/6]
    circling = Agent(0.2, 10.0/180*pi,
                     estimator=MonteCarloLocalization(initial_pose, 10))
    robot = RealRobot(initial_pose, 0.2, "black",
                      circling, delta_t, camera=RealCamera(map))
    
    # draw animation
    anim = @animate for t in 0:delta_t:30
      # world
      draw(world)

      # time
      annotate!(-3.5, 4.5, "t = $(t)", "black")

      # map
      draw!(map)

      # robot
      draw!(robot)
    end

    save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_particles.gif")
    gif(anim, fps=15, save_path)
  end
end