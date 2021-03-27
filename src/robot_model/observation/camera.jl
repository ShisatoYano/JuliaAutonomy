# class for camera observing landmark

using Plots
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))

mutable struct Camera
    map
    last_data
    dist_rng
    dir_rng

    # init
    function Camera(map::Map, 
                    dist_rng::Tuple=(0.5, 6.0), 
                    dir_rng::Tuple=(-pi/3, pi/3))
        self = new()
        self.map = map
        self.last_data = []
        self.dist_rng = dist_rng
        self.dir_rng = dir_rng
        return self
    end
end

function visible(self::Camera, obsrv::Array=nothing)
    if obsrv === nothing
        return false
    end

    return ((self.dist_rng[1] <= obsrv[1] <= self.dist_rng[2])
        && (self.dir_rng[1] <= obsrv[2] <= self.dir_rng[2]))
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
        obsrv = observation_function(cam_pose, lm.pose)
        if visible(self, obsrv)
            push!(observed, (obsrv, lm.id))
        end
    end
    self.last_data = observed
end

function draw!(self::Camera, cam_pose::Array)
    for lm in self.last_data
        x, y, theta = cam_pose[1], cam_pose[2], cam_pose[3]
        distance, direction = lm[1][1], lm[1][2]
        lx = x + distance * cos(direction + theta)
        ly = y + distance * sin(direction + theta)
        plot!([x, lx], [y, ly], color="pink",
              legend=false, aspect_ratio=true)
    end
end