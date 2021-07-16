# module for drawing goal flag

using Plots
pyplot()

mutable struct Goal
  pose
  radius
  value

  # init
  function Goal(x, y; radius=0.3, value=0.0)
    self = new()
    self.pose = [x, y]
    self.radius = radius
    self.value = value
    return self
  end
end

function inside(self::Goal, pose)
  if self.radius > sqrt((self.pose[1]-pose[1])^2 + (self.pose[2]-pose[2])^2)
    return true
  else
    return false
  end
end

function draw!(self::Goal)
  scatter!([self.pose[1]+0.1], [self.pose[2]+0.5], 
           markershape=:rtriangle, 
           markercolor=:red, 
           markersize=9)
  plot!([self.pose[1], self.pose[1]], [self.pose[2], self.pose[2]+0.6],
        color=:black)
end