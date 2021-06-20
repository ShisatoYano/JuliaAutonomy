# module for fast slam 1.0
# estimate robot's pose and landmark's position on map

using Distributions, LinearAlgebra, StatsBase

include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/slam/map_particle.jl"))

mutable struct FastSlam2
  particles
  motion_noise_stds
  motion_noise_rate_pdf
  dist_dev
  dir_dev
  max_likelihood_particle
  estimated_pose

  function FastSlam2(init_pose; particle_num=100, objects_num=0,
                     motion_noise_stds=Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20),
                     dist_dev_rate=0.14, dir_dev=0.05)
    self = new()
    self.particles = [MapParticle(init_pose, 1.0/particle_num, objects_num) for i in 1:particle_num]
    self.dist_dev = dist_dev_rate
    self.dir_dev = dir_dev
    self.max_likelihood_particle = self.particles[1]
    self.estimated_pose = self.max_likelihood_particle.pose
    
    v = motion_noise_stds
    c = diagm(0 => [v["nn"]^2, v["no"]^2, v["on"]^2, v["oo"]^2])
    self.motion_noise_stds = motion_noise_stds
    self.motion_noise_rate_pdf = MvNormal(c)
    return self
  end
end

function motion_update(self::FastSlam2, speed, yaw_rate, time_interval, observation)
  # create list of observed landmarks
  observed_landmarks = []
  for obs in observation
    # decide first partilce's map
    if self.particles[1].map.objects[obs[2]].cov !== nothing
      push!(observed_landmarks, obs)
    end
  end
  
  # update each particle's pose
  # considering observation
  if length(observed_landmarks) > 0
    for p in self.particles
      motion_update_2(p, speed, yaw_rate, time_interval, self.motion_noise_stds,
                      observed_landmarks, self.dist_dev, self.dir_dev)
    end  
  else
    for p in self.particles
      motion_update(p, speed, yaw_rate, time_interval, self.motion_noise_rate_pdf)
    end
  end
end

function set_max_likelihood_pose(self::FastSlam2)
  max_index = argmax([p.weight for p in self.particles])
  self.max_likelihood_particle = self.particles[max_index]
  self.estimated_pose = self.max_likelihood_particle.pose
end

function observation_update(self::FastSlam2, observation)
  for p in self.particles
    observation_update(p, observation, self.dist_dev, self.dir_dev)
  end
  set_max_likelihood_pose(self)
  resampling(self)
end

function resampling(self::FastSlam2)
  ws = [(if p.weight <= 0.0 1e-100 else p.weight end) for p in self.particles]
  
  ps = sample(self.particles, Weights(ws), length(self.particles))
  self.particles = [deepcopy(e) for e in ps]
  for p in self.particles
    p.weight = 1.0/length(self.particles)
  end
end

function draw!(self::FastSlam2)
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

  # estimated landmarks on map
  # the max likelihood particle
  for elm in self.max_likelihood_particle.map.objects
    draw!(elm)
  end
end