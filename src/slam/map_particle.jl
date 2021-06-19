# module for calculating particle motion
# particle has a map data for slam

using Distributions, LinearAlgebra, PDMats

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

function mat_H_m(mu_pose, obj_pose)
  obj_x, obj_y = obj_pose[1], obj_pose[2]
  mu_x, mu_y = mu_pose[1], mu_pose[2]
  mu_l = sqrt((mu_x - obj_x)^2 + (mu_y - obj_y)^2)
  return [(obj_x - mu_x)/mu_l (obj_y - mu_y)/mu_l;
          (mu_y - obj_y)/(mu_l^2) (obj_x - mu_x)/(mu_l^2)]
end

function mat_H_x(mu_pose, obj_pose)
  obj_x, obj_y = obj_pose[1], obj_pose[2]
  mu_x, mu_y = mu_pose[1], mu_pose[2]
  mu_l = sqrt((mu_x - obj_x)^2 + (mu_y - obj_y)^2)
  return [(mu_x - obj_x)/mu_l (mu_y - obj_y)/mu_l 0.0;
          (obj_y - mu_y)/(mu_l^2) (mu_x - obj_x)/(mu_l^2) -1.0]
end

function mat_Q(dist_dev, dir_dev)
  return [dist_dev^2 0.0;
          0.0 dir_dev^2]
end

function mat_M(speed, yaw_rate, time, stds)
  return diagm(0 => [stds["nn"]^2*abs(speed)/time + stds["no"]^2*abs(yaw_rate)/time,
                     stds["on"]^2*abs(speed)/time + stds["oo"]^2*abs(yaw_rate)/time])
end

function mat_A(speed, yaw_rate, time, theta)
  st, ct = sin(theta), cos(theta)
  stw, ctw = sin(theta + yaw_rate * time), cos(theta + yaw_rate * time)
  return [(stw - st)/yaw_rate  -speed/(yaw_rate^2)*(stw - st) + speed/yaw_rate*time*ctw;
          (-ctw + ct)/yaw_rate -speed/(yaw_rate^2)*(-ctw + ct) + speed/yaw_rate*time*stw;
          0                    time]
end

function params_for_drawing(pred_pose, landmark, dist_dev, dir_dev)
  # linearize observation function
  diff_x = pred_pose[1] - landmark.pose[1]
  diff_y = pred_pose[2] - landmark.pose[2]
  dist = hypot(diff_x, diff_y)
  Q = mat_Q(dist_dev * dist, dir_dev)
  pred_z = observation_function(pred_pose, landmark.pose)
  H_m = mat_H_m(pred_pose, landmark.pose) # 2x2
  H_x = mat_H_x(pred_pose, landmark.pose) # 2x3

  # calculate covariance matrix of sensor data
  # based on particle's pose and map
  Q_z = H_m * landmark.cov * H_m' + Q

  return pred_z, Q_z, H_x
end

function gauss_for_drawing(pred_pose, pred_cov, z, 
                           landmark, dist_dev, dir_dev)

end

function motion_update_2(self::MapParticle, speed, yaw_rate, 
                         time_interval, motion_noise_stds,
                         observation, dist_dev, dir_dev)
  # distribution after movement
  M = mat_M(speed, yaw_rate, time_interval, motion_noise_stds)
  A = mat_A(speed, yaw_rate, time_interval, self.pose[3])
  pred_cov = A * M * A'
  pred_pose = state_transition(speed, yaw_rate, time_interval, self.pose)

  # considering observation
  for obs in observation
    est_pose, est_cov = gauss_for_drawing() 
  end
end

function init_landmark_estimation(self::MapParticle, landmark, obs_pose,
                                  dist_dev_rate, dir_dev)
  lx = obs_pose[1] * cos(self.pose[3] + obs_pose[2]) + self.pose[1]
  ly = obs_pose[1] * sin(self.pose[3] + obs_pose[2]) + self.pose[2]
  landmark.pose = [lx, ly]
  H = mat_H(self.pose, landmark.pose)
  Q = mat_Q(dist_dev_rate * obs_pose[1], dir_dev)
  landmark.cov = inv(H' * inv(Q) * H)
end

function observation_update_landmark(self::MapParticle, landmark, obs_pose,
                                     dist_dev_rate, dir_dev)
  est_obs_pose = observation_function(self.pose, landmark.pose)
  # not calculate when distance is too close
  if est_obs_pose[1] > 0.01
    # calculate kalman gain
    H = mat_H(self.pose, landmark.pose)
    Q = mat_Q(dist_dev_rate * est_obs_pose[1], dir_dev)
    K = landmark.cov * H' * inv(Q + H*landmark.cov*H')

    # update weight
    Q_obs = H * landmark.cov * H' + Q
    self.weight *= pdf(MvNormal(est_obs_pose, Symmetric(Q_obs)), obs_pose)

    # update landmark estimation
    landmark.pose += K * (obs_pose - est_obs_pose)
    landmark.cov = (Matrix{Float64}(I, 2, 2) - K*H) * landmark.cov
  end
end

function observation_update(self::MapParticle, observation, 
                            dist_dev_rate, dir_dev)
  for obs in observation
    obs_pose = obs[1] # [distance, direction]
    obs_id = obs[2]
    landmark = self.map.objects[obs_id]

    if landmark.cov === nothing
      init_landmark_estimation(self, landmark, obs_pose, 
                               dist_dev_rate, dir_dev)
    else
      observation_update_landmark(self, landmark, obs_pose,
                                  dist_dev_rate, dir_dev)
    end
  end
end