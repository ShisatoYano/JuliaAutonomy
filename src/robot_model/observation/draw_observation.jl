# module for drawing landmarks observation with camera

module DrawObservation
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/landmark.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/robot.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/agent.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/camera.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        # robot pose
        pose1 = [-1, 1, pi/6]
        pose2 = [-2, -1, pi/5*6]
        pose3 = [0, 0, 0]

        # map
        map = Map()
        add_landmark(map, Landmark(2.0, -2.0))
        add_landmark(map, Landmark(-1.0, -3.0))
        add_landmark(map, Landmark(3.0, 3.0))

        # camera
        cam = Camera(map)
        observed = data(cam, pose2)

        println(observed)
    end
end