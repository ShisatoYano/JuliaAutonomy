# class for defining world coordinate system

using Plots
pyplot()

mutable struct World
    x_min
    x_max
    y_min
    y_max

    # init
    function World(x_min::Float64, x_max::Float64,
                   y_min::Float64, y_max::Float64)
        self = new()
        self.x_min = x_min
        self.x_max = x_max
        self.y_min = y_min
        self.y_max = y_max
        return self
    end
end

function draw(self::World)
    plot([], [], aspect_ratio=true,
         xlabel="X", ylabel="Y",
         xlims=(self.x_min, self.x_max),
         ylims=(self.y_min, self.y_max),
         legend=false)
end