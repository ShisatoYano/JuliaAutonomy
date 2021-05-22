# module for estimating pose by extended kalman filter

using Distributions, LinearAlgebra, StatsBase

include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/covariance_ellipse/covariance_ellipse.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/state_transition/state_transition.jl"))

mutable struct ExtendedKalmanFilter
  belief
  motion_noise_stds
  estimated_pose
  estimated_cov

  function ExtendedKalmanFilter(init_pose::Array;
                                motion_noise_stds::Dict=Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20),
                                env_map=nothing)
    self = new()
    self.belief = MvNormal([0.0, 0.0, 0.0], 
                           diagm(0 => [1e-10, 1e-10, 1e-10]))
    self.motion_noise_stds = motion_noise_stds
    self.estimated_pose = self.belief.μ
    self.estimated_cov = self.belief.Σ
    return self
  end
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

function mat_F(speed, yaw_rate, time, theta)
  F = diagm(0 => [1.0, 1.0, 1.0])
  F[1, 3] = speed / yaw_rate * (cos(theta + yaw_rate * time) - cos(theta))
  F[2, 3] = speed / yaw_rate * (sin(theta + yaw_rate * time) - sin(theta))
  return F
end

function motion_update(self::ExtendedKalmanFilter, speed, 
                       yaw_rate, time)
  if abs(yaw_rate) < 1e-5 # to prevent division by zero
    yaw_rate = 1e-5
  end
  M = mat_M(speed, yaw_rate, time, self.motion_noise_stds)
  A = mat_A(speed, yaw_rate, time, self.estimated_pose[3])
  F = mat_F(speed, yaw_rate, time, self.estimated_pose[3])
  self.estimated_cov = F * self.estimated_cov * F' + A * M * A'
  self.estimated_pose = state_transition(speed, yaw_rate, time, self.estimated_pose)
end

function observation_update(self::ExtendedKalmanFilter, observation)
  
end

function draw!(self::ExtendedKalmanFilter)
  draw_covariance_ellipse!(self.estimated_pose, self.estimated_cov, 3)
end