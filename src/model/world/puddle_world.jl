# module for defining world coordinate system
# puddle can be put

using Plots
pyplot()

mutable struct PuddleWorld
  x_min
  x_max
  y_min
  y_max
  objects
  delta_time
  end_time
  is_test
  save_path

  # init
  function PuddleWorld(x_min::Float64, x_max::Float64,
                       y_min::Float64, y_max::Float64;
                       delta_time=0.1, end_time=30,
                       is_test=false, save_path=nothing)
    self = new()
    self.x_min = x_min
    self.x_max = x_max
    self.y_min = y_min
    self.y_max = y_max
    self.objects = []
    self.delta_time = delta_time
    self.end_time = end_time
    self.is_test = is_test
    self.save_path = save_path
    return self
  end
end

function append(self::PuddleWorld, obj)
  push!(self.objects, obj)
end

function one_step(self::PuddleWorld, delta_time)
  plot([], [], aspect_ratio=true, xlabel="X", ylabel="Y",
       xlims=(self.x_min, self.x_max), ylims=(self.y_min, self.y_max),
       legend=false)
  annotate!(-3.5, 4.5, "t = $(delta_time)", "black")
  for obj in self.objects
    draw!(obj)
  end
end

function draw(self::PuddleWorld) 
  if self.is_test
    for t in 0:self.delta_time:10
      one_step(self, t)
    end
  else
    anime = @animate for t in 0:self.delta_time:self.end_time
      one_step(self, t)
    end
    gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], self.save_path))
  end
end