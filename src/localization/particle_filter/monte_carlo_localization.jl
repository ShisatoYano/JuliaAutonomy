include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/particle.jl"))

mutable struct MonteCarloLocalization
  particles

  # init
  function MonteCarloLocalization(init_pose::Array, num::Int64)
    self = new()
    self.particles = [Particle(init_pose) for i in 1:num]
    return self
  end
end

function draw!(self::MonteCarloLocalization)
  px = [p.pose[1] for p in self.particles]
  py = [p.pose[2] for p in self.particles]
  vx = [cos(p.pose[3]) for p in self.particles]
  vy = [sin(p.pose[3]) for p in self.particles]
  quiver!(px, py, quiver=(vx, vy), aspect_ratio=:equal)
end