# class for drawing map

using Plots
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/landmark.jl"))

mutable struct Map
    landmarks

    # init
    function Map()
        self = new()
        self.landmarks = []
        return self
    end
end

function add_landmark(self::Map, landmark::Landmark)
    push!(self.landmarks, landmark)
    set_id(landmark, length(self.landmarks))
end

function draw!(self::Map)
    for lm in self.landmarks
        draw!(lm)
    end
end