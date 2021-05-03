using Distributions, LinearAlgebra

include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/particle.jl"))

mutable struct MonteCarloLocalization
  particles
  motion_noise_rate_pdf

  # init
  function MonteCarloLocalization(init_pose::Array, num::Int64,
                                  motion_noise_stds::Dict)
    self = new()
    self.particles = [Particle(init_pose) for i in 1:num]
    v = motion_noise_stds
    c = diagm(0 => [v["nn"]^2, v["no"]^2, v["on"]^2, v["oo"]^2])
    self.motion_noise_rate_pdf = MvNormal(c)
    return self
  end
end

function motion_update(self::MonteCarloLocalization, speed, yaw_rate, time_interval)
  for p in self.particles
    motion_update(p, speed, yaw_rate, time_interval, self.motion_noise_rate_pdf)
  end
end

function draw!(self::MonteCarloLocalization)
  px = [p.pose[1] for p in self.particles]
  py = [p.pose[2] for p in self.particles]
  k = 0.5
  vx = [k * cos(p.pose[3]) for p in self.particles]
  vy = [k * sin(p.pose[3]) for p in self.particles]
  quiver!(px, py, quiver=(vx, vy), aspect_ratio=true)
end