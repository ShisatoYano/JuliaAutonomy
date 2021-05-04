using Distributions, LinearAlgebra, StatsBase

include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/particle.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/observation/map.jl"))

mutable struct MonteCarloLocalization
  particles
  motion_noise_rate_pdf
  map
  dist_dev
  dir_dev

  # init
  function MonteCarloLocalization(init_pose::Array, num::Int64,
                                  motion_noise_stds::Dict;
                                  env_map=nothing,
                                  dist_dev_rate=0.0,
                                  dir_dev=0.0)
    self = new()
    self.particles = [Particle(init_pose, 1.0/num) for i in 1:num]
    self.map = env_map
    self.dist_dev = dist_dev_rate
    self.dir_dev = dir_dev
    
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

function observation_update(self::MonteCarloLocalization, observation)
  for p in self.particles
    observation_update(p, observation, self.map, self.dist_dev, self.dir_dev)
  end
  resampling(self)
end

function resampling(self::MonteCarloLocalization)
  ws = [(if p.weight <= 0.0 1e-100 else p.weight end) for p in self.particles]
  ps = sample(self.particles, Weights(ws), length(self.particles))
  self.particles = [deepcopy(e) for e in ps]
  for p in self.particles
    p.weight = 1.0/length(self.particles)
  end
end

function draw!(self::MonteCarloLocalization)
  px = [p.pose[1] for p in self.particles]
  py = [p.pose[2] for p in self.particles]
  k = 0.5
  vx = [cos(p.pose[3])*k*p.weight*length(self.particles) for p in self.particles]
  vy = [sin(p.pose[3])*k*p.weight*length(self.particles) for p in self.particles]
  quiver!(px, py, quiver=(vx, vy), aspect_ratio=true, color="blue")
end