# module for estimating pose by monte carlo localization
# based on particle filter
# particle num is decided by kld sampling
# parameter nn: range std on straight movement
# parameter no: range std on rotation movement
# parameter on: direction std on straight movement
# parameter oo: direction std on rotation movement

using Distributions, LinearAlgebra, StatsBase

include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/particle/particle.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/state_transition/state_transition.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/observation_function/observation_function.jl"))

mutable struct KldMcl
  particles
  max_num
  widths
  epsilon
  delta
  bin_num
  motion_noise_rate_pdf
  map
  dist_dev
  dir_dev
  max_likelihood_particle
  estimated_pose

  function KldMcl(init_pose::Array, max_num::Int64;
                  motion_noise_stds::Dict=Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20),
                  env_map=nothing, dist_dev_rate=0.14, dir_dev=0.05,
                  widths=[0.2, 0.2, pi/18], epsilon=0.1, delta=0.01)
    self = new()
    self.particles = [Particle(init_pose, 1.0)] # initial particle num is one
    self.map = env_map
    self.dist_dev = dist_dev_rate
    self.dir_dev = dir_dev
    self.max_likelihood_particle = self.particles[1]
    self.estimated_pose = self.max_likelihood_particle.pose
    
    # parameters for kld sampling
    self.widths = widths # width of x,y,theta's bin
    self.max_num = max_num # maximum particle num
    self.epsilon = epsilon # ϵ
    self.delta = delta # δ
    self.bin_num = 0 # num of bin

    v = motion_noise_stds
    c = diagm(0 => [v["nn"]^2, v["no"]^2, v["on"]^2, v["oo"]^2])
    self.motion_noise_rate_pdf = MvNormal(c)
    return self
  end
end

function motion_update(self::KldMcl, speed, yaw_rate, time_interval)
  ws = [(if p.weight <= 0.0 1e-100 else p.weight end) for p in self.particles]

  new_particles = []
  bins = Set()
  for i in 1:self.max_num
    chosen_p = sample(self.particles, Weights(ws)) # choose one particle randomly
    p = deepcopy(chosen_p)
    motion_update(p, speed, yaw_rate, time_interval, self.motion_noise_rate_pdf)
    push!(bins, [Int(floor(e)) for e in p.pose./self.widths])
    push!(new_particles, p)

    if length(bins) > 1
      self.bin_num = length(bins)
    else
      self.bin_num = 2
    end

    if length(new_particles) > ceil(quantile(Chisq(self.bin_num-1), 1-self.delta)/(2*self.epsilon))
      break
    end
  end

  self.particles = new_particles
  for i in 1:length(self.particles) # normalization
    self.particles[i].weight = 1.0/length(self.particles)
  end
end

function set_max_likelihood_pose(self::KldMcl)
  max_index = argmax([p.weight for p in self.particles])
  self.max_likelihood_particle = self.particles[max_index]
  self.estimated_pose = self.max_likelihood_particle.pose
end

function observation_update(self::KldMcl, observation)
  for p in self.particles
    observation_update(p, observation, self.map, self.dist_dev, self.dir_dev)
  end
  set_max_likelihood_pose(self)
end

function draw!(self::KldMcl)
  k = 0.5 # scale for length of arrows
  # all of particles
  px = [p.pose[1] for p in self.particles]
  py = [p.pose[2] for p in self.particles]
  vx = [cos(p.pose[3])*k for p in self.particles]
  vy = [sin(p.pose[3])*k for p in self.particles]
  quiver!(px, py, quiver=(vx, vy), aspect_ratio=true, color="blue")
  # maximum likelihood particle
  mx = [self.estimated_pose[1]]
  my = [self.estimated_pose[2]]
  mvx = [cos(self.estimated_pose[3])*k]
  mvy = [sin(self.estimated_pose[3])*k]
  quiver!(mx, my, quiver=(mvx, mvy), aspect_ratio=true, color="red")
  annotate!(-4.5, -4.5, text("particle:$(length(self.particles)), bin:$(self.bin_num)", :left, :black))
end