# module for estimating pose by monte carlo localization
# based on particle filter
# particles are resampled by systematic sampling
# parameter nn: range std on straight movement
# parameter no: range std on rotation movement
# parameter on: direction std on straight movement
# parameter oo: direction std on rotation movement

using Distributions, LinearAlgebra, StatsBase

include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/particle/particle.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))

mutable struct MclSysSamp
  particles
  motion_noise_rate_pdf
  map
  dist_dev
  dir_dev
  max_likelihood_particle
  estimated_pose

  # init
  function MclSysSamp(init_pose::Array, num::Int64,
                      motion_noise_stds::Dict;
                      env_map=nothing,
                      dist_dev_rate=0.0,
                      dir_dev=0.0)
    self = new()
    self.particles = [Particle(init_pose, 1.0/num) for i in 1:num]
    self.map = env_map
    self.dist_dev = dist_dev_rate
    self.dir_dev = dir_dev
    self.max_likelihood_particle = self.particles[1]
    self.estimated_pose = self.max_likelihood_particle.pose
    
    v = motion_noise_stds
    c = diagm(0 => [v["nn"]^2, v["no"]^2, v["on"]^2, v["oo"]^2])
    self.motion_noise_rate_pdf = MvNormal(c)
    return self
  end
end

function motion_update(self::MclSysSamp, speed, yaw_rate, time_interval)
  for p in self.particles
    motion_update(p, speed, yaw_rate, time_interval, self.motion_noise_rate_pdf)
  end
end

function set_max_likelihood_pose(self::MclSysSamp)
  max_index = argmax([p.weight for p in self.particles])
  self.max_likelihood_particle = self.particles[max_index]
  self.estimated_pose = self.max_likelihood_particle.pose
end

function observation_update(self::MclSysSamp, observation)
  for p in self.particles
    observation_update(p, observation, self.map, self.dist_dev, self.dir_dev)
  end
  set_max_likelihood_pose(self)
  resampling(self)
end

function systematic_sample(particles, weights, sample_num)
  sampled_particles = [] 

  step = weights[end]/sample_num
  r = rand(Uniform(0.0, step))

  current_index = 1
  while length(sampled_particles) < sample_num
    if r < weights[current_index]
      push!(sampled_particles, particles[current_index])
      r += step
    else
      current_index += 1
    end
  end

  return sampled_particles
end

function resampling(self::MclSysSamp)
  ws = [(if p.weight <= 0.0 1e-100 else p.weight end) for p in self.particles]
  
  ps = systematic_sample(self.particles, cumsum(ws), length(self.particles))

  self.particles = [deepcopy(e) for e in ps]
  for p in self.particles
    p.weight = 1.0/length(self.particles)
  end
end

function draw!(self::MclSysSamp)
  k = 0.5 # scale for length of arrows
  # all of particles
  px = [p.pose[1] for p in self.particles]
  py = [p.pose[2] for p in self.particles]
  vx = [cos(p.pose[3])*k*p.weight*length(self.particles) for p in self.particles]
  vy = [sin(p.pose[3])*k*p.weight*length(self.particles) for p in self.particles]
  quiver!(px, py, quiver=(vx, vy), aspect_ratio=true, color="blue")
  # maximum likelihood particle
  mx = [self.estimated_pose[1]]
  my = [self.estimated_pose[2]]
  mvx = [cos(self.estimated_pose[3])*k]
  mvy = [sin(self.estimated_pose[3])*k]
  quiver!(mx, my, quiver=(mvx, mvy), aspect_ratio=true, color="red")
end