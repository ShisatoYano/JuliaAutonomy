# module for drawing 100 moving robots
# add random noise against robot moving

module MoveRandomNoise
    include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/world.jl"))
    include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_robot/real_robot.jl"))

    function main()
        # world coordinate system
        world = World(-5.0, 5.0, -5.0, 5.0)

        delta_time = 0.1

        # robot objects
        robots = []
        # has random noise
        r = RealRobot([0.0, 0.0, 0.0], 0.2, "gray",
                      Agent(0.2, 10.0/180*pi),
                      delta_time,
                      noise_per_meter=5, 
                      noise_std=pi/30)
        push!(robots, r)
        
        # no random noise
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

        save_path = joinpath(split(@__FILE__, "src")[1], "gif/move_random_noise.gif")
        gif(anim, fps=15, save_path)
    end
end