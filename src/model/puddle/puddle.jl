# module for representing puddle

using Plots
pyplot()

mutable struct Puddle
  lower_left
  upper_right
  depth

  # init
  function Puddle(lower_left, upper_right, depth)
    self = new()
    self.lower_left = lower_left
    self.upper_right = upper_right
    self.depth = depth
    return self
  end
end

function draw!(self::Puddle)
  w = self.upper_right[1] - self.lower_left[1]
  h = self.upper_right[2] - self.lower_left[2]
  rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])
  plot!(rectangle(w, h, self.lower_left[1], self.lower_left[2]),
        color=:blue, alpha=self.depth, aspect_ratio=true,
        legend=false)
end

function inside(self::Puddle, pose)
  result = true
  for i in [1, 2]
    if (self.lower_left[i] > pose[i]) || 
       (self.upper_right[i] < pose[i])
      result = false
    end
  end
  return result
end