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

        # agents
        straight = Agent(0.2, 0.0)
        circling = Agent(0.2, 10.0/180*pi)

        # initial poses
        pose_st = [-1, 1, pi/6]
        pose_cir = [-2, -1, pi/5*6]

        # map
        map = Map()
        add_landmark(map, Landmark(2.0, -2.0))
        add_landmark(map, Landmark(-1.0, -3.0))
        add_landmark(map, Landmark(3.0, 3.0))

        # camera
        cam = Camera(map)

        # draw animation
        dt = 1
        anim = @animate for t in 0:dt:50
            # world
            draw(world)

            # time
            annotate!(-3.5, 4.5, "t = $(t)", "black")

            # map
            draw!(map)

            # robots
            draw!(Robot(pose_st, 0.2, "black"))
            draw!(Robot(pose_cir, 0.2, "red"))

            # observation
            data(cam, pose_st); draw!(cam, pose_st)
            data(cam, pose_cir); draw!(cam, pose_cir)

            # decision for next step
            # straight
            spd_st, yr_st = decision(straight)
            pose_st = state_transition(spd_st, yr_st, dt, pose_st)
            # circling
            spd_cir, yr_cir = decision(circling)
            pose_cir = state_transition(spd_cir, yr_cir, dt, pose_cir)
        end
        save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_observation.gif")
        gif(anim, fps=10, save_path)
    end
end