# draw moving robots
# add bias error of movement speed

module MoveSpeedBias
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        delta_time = 0.1

        # robot objects
        no_bias_robot = RealRobot([0.0, 0.0, 0.0], 0.2, "gray",
                                  Agent(0.2, 10.0/180*pi),
                                  delta_time, 0, 0.0, [0.0, 0.0])
        bias_robot = RealRobot([0.0, 0.0, 0.0], 0.2, "red",
                               Agent(0.2, 10.0/180*pi),
                               delta_time, 0, 0.0, [0.2, 0.2])
        
        # draw animation
        anim = @animate for t in 0:delta_time:30
            # world
            draw(world)

            # time
            annotate!(-3.5, 4.5, "t = $(t)", "black")

            # robots
            draw!(no_bias_robot)
            draw!(bias_robot)
        end

        save_path = joinpath(split(@__FILE__, "src")[1], "gif/move_speed_bias.gif")
        gif(anim, fps=15, save_path)
    end
end
