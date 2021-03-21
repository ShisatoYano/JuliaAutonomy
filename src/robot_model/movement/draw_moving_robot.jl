# module for drawing 2 moving robots and 1 staying robot

module DrawMovingRobot
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/robot.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/agent.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        # agents
        straight = Agent(0.2, 0.0)
        circling = Agent(0.2, 10.0/180*pi)
        staying = Agent(0.0, 0.0)

        # initial pose
        pose1 = [-1, 1, pi/6] # straight
        pose2 = [-2, -1, pi/5*6] # circling
        pose3 = [0, 0, 0] # staying

        # trajectory
        x1, y1 = [], []
        x2, y2 = [], []
        x3, y3 = [], []

        # draw animation
        delta_time = 1
        anim = @animate for t in 0:delta_time:30
            # world
            draw(world)

            # robots
            draw!(Robot(pose1, 0.2, "black", straight))
            draw!(Robot(pose2, 0.2, "red", circling))
            draw!(Robot(pose3, 0.2, "blue", staying))

            # trajectory
            push!(x1, pose1[1]), push!(y1, pose1[2])
            plot!(x1, y1, color="black", legend=false, aspect_ratio=true)
            push!(x2, pose2[1]), push!(y2, pose2[2])
            plot!(x2, y2, color="red", legend=false, aspect_ratio=true)
            push!(x3, pose3[1]), push!(y3, pose3[2])
            plot!(x3, y3, color="blue", legend=false, aspect_ratio=true)

            # time
            annotate!(-3.5, 4.5, "t = $(t)", "black")

            # decision for next step
            # straight
            speed1, yaw_rate1 = decision(straight)
            pose1 = state_transition(speed1, yaw_rate1, delta_time, pose1)
            # circling
            speed2, yaw_rate2 = decision(circling)
            pose2 = state_transition(speed2, yaw_rate2, delta_time, pose2)
            # staying
            speed3, yaw_rate3 = decision(staying)
            pose3 = state_transition(speed3, yaw_rate3, delta_time, pose3)
        end
        save_path = joinpath(split(@__FILE__, "src")[1], "gif/draw_moving_robot.gif")
        gif(anim, fps=10, save_path) 
    end
end