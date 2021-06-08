# module for object estimated by slam

using Plots
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/common/covariance_ellipse/covariance_ellipse.jl"))

mutable struct EstimatedObject
  pose
  id
  shape
  color
  size
  cov

  # init
  function EstimatedObject(x, y; shape=:star, color=:blue,
                           size=15, id=-1, cov=nothing)
    self = new()
    self.pose = [x, y]
    self.id = id
    self.shape = shape
    self.color = color
    self.size = size
    self.cov = [1 0;
                0 2]
    return self
  end
end

function draw!(self::EstimatedObject)
  if self.cov != nothing
    scatter!([self.pose[1]], [self.pose[2]], markershape=self.shape, 
             markercolor=self.color, markersize=self.size)
    if self.id !== -1
      annotate!(self.pose[1], self.pose[2], 
                text("id:$(self.id)", :black, :left, 10))
    end
    draw_covariance_ellipse!(self.pose, self.cov, 3)  
  end
end