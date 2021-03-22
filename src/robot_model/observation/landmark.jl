# class for drawing landmark

using Plots
pyplot()

mutable struct Landmark
    pose
    id

    # init
    function Landmark(x::Float64, y::Float64)
        self = new()
        self.pose = [x, y]
        self.id = -1
        return self
    end
end

function set_id(self::Landmark, id::Int64)
    self.id = id
end

function draw!(self::Landmark)
    scatter!([self.pose[1]], [self.pose[2]], markershape=:star, 
             markercolor=:orange, markersize=15)
    annotate!(self.pose[1], self.pose[2], 
              text("id:$(self.id)", :black, :left, 10))
end