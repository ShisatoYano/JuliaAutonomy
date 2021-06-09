# module for calculating particle motion
# particle has a map data for slam

using Distributions, LinearAlgebra

include(joinpath(split(@__FILE__, "src")[1], "src/common/state_transition/state_transition.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/observation_function/observation_function.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/slam/estimated_object.jl"))

mutable struct MapParticle
  pose
  weight
  object_num
  map

  # init
  function MapParticle(init_pose, weight, object_num)
    self = new()
    self.pose = init_pose
    self.weight = weight
    self.object_num = object_num
    self.map = Map()
    for i in 1:object_num
      add_object(self.map, EstimatedObject(0.0, 0.0, id=i))
    end
    return self
  end
end

function motion_update(self::MapParticle, speed, yaw_rate, 
                       time_interval, noise_rate_pdf)
  ns = rand(noise_rate_pdf) # [nn, no, on, oo]
  noised_spd = speed + ns[1]*sqrt(abs(speed)/time_interval) + ns[2]*sqrt(abs(yaw_rate)/time_interval)
  noised_yr = yaw_rate + ns[3]*sqrt(abs(speed)/time_interval) + ns[4]*sqrt(abs(yaw_rate)/time_interval)
  self.pose = state_transition(noised_spd, noised_yr, time_interval, self.pose)
end

function observation_update(self::MapParticle, observation, 
                            dist_dev_rate, dir_dev)
  for obs in observation
    obs_pose = obs[1] # [distance, direction]
    obs_id = obs[2]
    landmark = self.map.objects[obs_id]

    if landmark.cov === nothing
      # init landmark estimation
    end
  end
end