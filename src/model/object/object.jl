# module for drawing object

using Plots
pyplot()

mutable struct Object
    pose
    id
    shape
    color
    size

    # init
    function Object(x::Float64, y::Float64; shape=:star, 
                    color=:orange, size=15, id=-1)
        self = new()
        self.pose = [x, y]
        self.id = id
        self.shape = shape
        self.color = color
        self.size = size
        return self
    end
end

function draw!(self::Object)
    scatter!([self.pose[1]], [self.pose[2]], markershape=self.shape, 
             markercolor=self.color, markersize=self.size)
    if self.id !== -1
        annotate!(self.pose[1], self.pose[2], 
                  text("id:$(self.id)", :black, :left, 10))
    end
end