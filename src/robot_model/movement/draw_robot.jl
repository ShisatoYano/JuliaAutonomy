# module for drawing robots on world coordinate

module DrawRobot
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/robot.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/agent.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)
        
        # robot model
        robot1 = Robot([2, 3, pi/6], 0.2, "black", Agent(0.1, 1.0))
        robot2 = Robot([-2, -1, pi/5*6], 0.2, "red", Agent(0.1, 1.0))

        # draw
        draw(world)
        draw!(robot1)
        draw!(robot2)

        # save as .png
        save_path = joinpath(split(@__FILE__, "src")[1], "img/draw_robot.png")
        savefig(save_path)
    end
end