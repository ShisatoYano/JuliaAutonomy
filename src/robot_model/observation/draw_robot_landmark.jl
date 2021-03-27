# module for drawing robots and landmarks

module DrawRobotLandmark
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/landmark.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/robot.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        # pose
        pose1 = [-1, 1, pi/6]
        pose2 = [-2, -1, pi/5*6]
        pose3 = [0, 0, 0]

        # map
        map = Map()
        add_landmark(map, Landmark(2.0, -2.0))
        add_landmark(map, Landmark(-1.0, -3.0))
        add_landmark(map, Landmark(3.0, 3.0))

        # animation
        delta_time = 1.0
        anim = @animate for t in 0.0:delta_time:10.0
            # world
            draw(world)

            # time
            annotate!(-3.0, 4.5, "t = $(t)[s]", "black")

            # robots
            draw!(Robot(pose1, 0.2, "black"))
            draw!(Robot(pose2, 0.2, "red"))
            draw!(Robot(pose3, 0.2, "blue"))

            # map
            draw!(map)
        end
        save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_robot_landmark.gif")
        gif(anim, fps=10, save_path)
    end
end