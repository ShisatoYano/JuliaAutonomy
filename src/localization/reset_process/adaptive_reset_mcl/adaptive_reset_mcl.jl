# module for estimating pose by monte carlo localization
# based on particle filter
# particles are resampled by random sampling
# considering false estimation by reset process
# adaptive reset

using Distributions, LinearAlgebra, StatsBase

include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/particle/particle.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))

mutable struct AdaptiveResetMcl
  particles
  motion_noise_rate_pdf
  map
  dist_dev
  dir_dev
  max_likelihood_particle
  estimated_pose
  alpha_threshold
  amcl_params
  slow_term_alpha
  fast_term_alpha

  # init
  function AdaptiveResetMcl(init_pose::Array, num::Int64;
                            motion_noise_stds::Dict=Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20),
                            env_map=nothing, dist_dev_rate=0.14, dir_dev=0.05,
                            alpha_threshold=0.001,
                            amcl_params::Dict=Dict("slow"=>0.001, "fast"=>0.1, "nu"=>3.0))
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

    self.alpha_threshold = alpha_threshold
    self.amcl_params = amcl_params
    self.slow_term_alpha = 1.0
    self.fast_term_alpha = 1.0

    return self
  end
end

function motion_update(self::AdaptiveResetMcl, speed, yaw_rate, time_interval)
  for p in self.particles
    motion_update(p, speed, yaw_rate, time_interval, self.motion_noise_rate_pdf)
  end
end

function set_max_likelihood_pose(self::AdaptiveResetMcl)
  max_index = argmax([p.weight for p in self.particles])
  self.max_likelihood_particle = self.particles[max_index]
  self.estimated_pose = self.max_likelihood_particle.pose
end

function sensor_reset_draw(self::AdaptiveResetMcl, p::Particle, obj_pose::Array, obs_data::Array)
  # distance and direction from nearest observation
  dir_from_obs = rand(Uniform(-pi, pi))
  dist_from_obs = rand(Normal(obs_data[1], (obs_data[1]*self.dist_dev)^2))

  # particle's position
  p.pose[1] = obj_pose[1] + dist_from_obs * cos(dir_from_obs)
  p.pose[2] = obj_pose[2] + dist_from_obs * sin(dir_from_obs)

  # particle's direction
  dir_to_obs = rand(Normal(obs_data[2], self.dir_dev^2))
  p.pose[3] = atan(obj_pose[2]-p.pose[2], obj_pose[1]-p.pose[1]) - dir_to_obs

  # normalize weight
  p.weight = 1.0 / length(self.particles)
end

function adaptive_reset(self::AdaptiveResetMcl, observation)
  if length(observation) > 0
    # decide how many particles are reset
    alpha = sum([p.weight for p in self.particles])
    self.slow_term_alpha += self.amcl_params["slow"] * (alpha - self.slow_term_alpha)
    self.fast_term_alpha += self.amcl_params["fast"] * (alpha - self.fast_term_alpha)
    reset_num = length(self.particles) * maximum([0, (1.0 - self.amcl_params["nu"]*self.fast_term_alpha/self.slow_term_alpha)])
    
    resampling(self)

    nearest_idx = argmin([obs[1][1] for obs in observation])
    data = observation[nearest_idx][1]
    id = observation[nearest_idx][2]
    reset_particles = sample(self.particles, Int64(floor(reset_num)))
    if length(reset_particles) > 0
      for p in reset_particles
        sensor_reset_draw(self, p, self.map.objects[id].pose, data)
      end
    end
  end
end

function observation_update(self::AdaptiveResetMcl, observation)
  for p in self.particles
    observation_update(p, observation, self.map, self.dist_dev, self.dir_dev)
  end

  set_max_likelihood_pose(self)

  adaptive_reset(self, observation)
end

function resampling(self::AdaptiveResetMcl)
  ws = [(if p.weight <= 0.0 1e-100 else p.weight end) for p in self.particles]
  
  ps = sample(self.particles, Weights(ws), length(self.particles))
  self.particles = [deepcopy(e) for e in ps]
  for p in self.particles
    p.weight = 1.0/length(self.particles)
  end
end

function draw!(self::AdaptiveResetMcl)
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
end