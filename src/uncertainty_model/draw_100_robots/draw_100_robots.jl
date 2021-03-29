# module for drawing 100 moving robots

module Draw100Robots
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/agent.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        # initial pose
        circling = Agent(0.2, 10.0/180*pi)
        robot = RealRobot([0, 0, 0], 0.2, "black")

        # draw animation
        delta_time = 0.1
        anim = @animate for t in 0:delta_time:30
            # world
            draw(world)

            # time
            annotate!(-3.5, 4.5, "t = $(t)", "black")

            # robot
            draw!(robot)
            spd, yr = decision(circling)
            pose = state_transition(spd, yr, delta_time, pose)
            # for i in 1:100
            #     circling = Agent(0.2, 10.0/180*pi)
            #     robot = RealRobot(pose, 0.2, "black")
            #     draw!(robot)
            #     spd, yr = decision(circling)
            #     pose = state_transition(spd, yr, delta_time, pose)
            # end
        end

        save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_100_robots.gif")
        gif(anim, fps=15, save_path)
    end
end