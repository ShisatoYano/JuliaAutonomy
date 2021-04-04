# module for drawing 100 moving robots
# one of them move normally and the others sometimes are kidnapped

module MoveKidnap
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        delta_time = 0.1

        # robot objects
        robots = []
        # stuck
        for i in 1:1
            r = RealRobot([0.0, 0.0, 0.0], 0.2, "gray",
                          Agent(0.2, 10.0/180*pi),
                          delta_time, 0, 0.0, [0.0, 0.0],
                          60.0, 60.0,
                          5.0, [-5.0, 5.0], [-5.0, 5.0])
            push!(robots, r)
        end
        # no stuck
        r = RealRobot([0.0, 0.0, 0.0], 0.2, "red",
                      Agent(0.2, 10.0/180*pi),
                      delta_time, 0, 0.0, [0.0, 0.0],
                      1e100, 1e-100,
                      1e100, [-5.0, 5.0], [-5.0, 5.0])
        push!(robots, r)

        # draw animation
        anim = @animate for t in 0:delta_time:30
            # world
            draw(world)

            # time
            annotate!(-3.5, 4.5, "t = $(t)", "black")

            # robot
            for r in robots
                draw!(r)
            end
        end

        save_path = joinpath(split(@__FILE__, "src")[1], "gif/move_kidnap_1.gif")
        gif(anim, fps=15, save_path)
    end
end