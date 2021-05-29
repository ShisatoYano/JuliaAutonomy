# module for calculating particle motion

using Distributions, LinearAlgebra

include(joinpath(split(@__FILE__, "src")[1], "src/common/state_transition/state_transition.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/observation_function/observation_function.jl"))

mutable struct Particle
  pose
  weight

  # init
  function Particle(init_pose::Array, weight::Float64)
    self = new()
    self.pose = init_pose
    self.weight = weight
    return self
  end
end

function motion_update(self::Particle, speed, yaw_rate, 
                       time_interval, noise_rate_pdf)
  ns = rand(noise_rate_pdf) # [nn, no, on, oo]
  noised_spd = speed + ns[1]*sqrt(abs(speed)/time_interval) + ns[2]*sqrt(abs(yaw_rate)/time_interval)
  noised_yr = yaw_rate + ns[3]*sqrt(abs(speed)/time_interval) + ns[4]*sqrt(abs(yaw_rate)/time_interval)
  self.pose = state_transition(noised_spd, noised_yr, time_interval, self.pose)
end

function observation_update(self::Particle, observation, env_map, 
                            dist_dev_rate, dir_dev)
  for obs in observation
    obs_pose = obs[1] # [distance, direction]
    obs_id = obs[2]

    # calculate distance and direction from particle pos to object
    pos_on_map = env_map.objects[obs_id].pose
    obs_from_particle = observation_function(self.pose, pos_on_map) # [distance, direction]

    # calculate likelihood
    dist_dev = dist_dev_rate * obs_from_particle[1]
    cov = diagm(0 => [dist_dev^2, dir_dev^2])
    self.weight *= pdf(MvNormal(obs_from_particle, cov), obs_pose)
  end
end