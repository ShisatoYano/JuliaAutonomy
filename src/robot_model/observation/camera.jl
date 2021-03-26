# class for camera observing landmark

using Plots
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))

mutable struct Camera
    map

    # init
    function Camera(map::Map)
        self = new()
        self.map = map
        return self
    end
end

function observation_function(cam_pose::Array, obj_pos::Array)
    diff_x = obj_pos[1] - cam_pose[1]
    diff_y = obj_pos[2] - cam_pose[2]
    phi = atan(diff_y, diff_x) - cam_pose[3]
    while phi >= pi
        phi -= 2 * pi
    end
    while phi < -pi
        phi += 2 * pi
    end
    return [hypot(diff_x, diff_y), phi]
end

function data(self::Camera, cam_pose::Array)
    observed = []
    for lm in self.map.landmarks
        p = observation_function(cam_pose, lm.pose)
        push!(observed, (p, lm.id))
    end
    return observed
end