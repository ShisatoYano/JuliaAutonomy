# module for drawing goal flag

using Plots
pyplot()

mutable struct Goal
  pose

  # init
  function Goal(x::Float64, y::Float64)
    self = new()
    self.pose = [x, y]
    return self
  end
end

function draw!(self::Goal)
  scatter!([self.pose[1]+0.16], [self.pose[2]+0.5], 
           markershape=:rtriangle, 
           markercolor=:red, 
           markersize=15)
  plot!([self.pose[1], self.pose[1]], [self.pose[2], self.pose[2]+0.6],
        color=:black)
end