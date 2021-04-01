# module for drawing 100 moving robots

module Draw100Robots
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        delta_time = 0.1

        # robot objects
        robots = []
        for i in 1:100
            r = RealRobot([0.0, 0.0, 0.0], 0.2, "gray",
                          Agent(0.2, 10.0/180*pi),
                          delta_time, 5, pi/30)
            push!(robots, r)
        end

        # draw animation
        anim = @animate for t in 0:delta_time:40
            # world
            draw(world)

            # time
            annotate!(-3.5, 4.5, "t = $(t)", "black")

            # robot
            for r in robots
                draw!(r)
            end
        end

        save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_100_robots.gif")
        gif(anim, fps=15, save_path)
    end
end