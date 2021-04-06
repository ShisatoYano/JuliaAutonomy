# module for drawing 100 moving robots
# one of them move normally and the others sometimes stop
# because of stuck

module MoveStuck
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        delta_time = 0.1

        # robot objects
        robots = []
        # stuck
        r = RealRobot([0.0, 0.0, 0.0], 0.2, "gray",
                      Agent(0.2, 10.0/180*pi),
                      delta_time,
                      exp_stuck_time=60.0,
                      exp_escape_time=60.0)
        push!(robots, r)
        
        # no stuck
        r = RealRobot([0.0, 0.0, 0.0], 0.2, "red",
                      Agent(0.2, 10.0/180*pi),
                      delta_time)
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

        save_path = joinpath(split(@__FILE__, "src")[1], "gif/move_stuck.gif")
        gif(anim, fps=15, save_path)
    end
end