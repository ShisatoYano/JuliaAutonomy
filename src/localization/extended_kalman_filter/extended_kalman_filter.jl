# module for estimating pose by extended kalman filter

using Distributions, LinearAlgebra, StatsBase

include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/covariance_ellipse/covariance_ellipse.jl"))

mutable struct ExtendedKalmanFilter
  belief
  estimated_pose

  function ExtendedKalmanFilter(init_pose::Array;
                                motion_noise_stds::Dict=Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20),
                                env_map=nothing)
    self = new()
    self.belief = MvNormal([0.0, 0.0, pi/4], 
                           diagm(0 => [0.1, 0.2, 0.01]))
    self.estimated_pose = self.belief.μ
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
  
end

function motion_update(self::ExtendedKalmanFilter, speed, 
                       yaw_rate, time)
  
end

function observation_update(self::ExtendedKalmanFilter, observation)
  
end

function draw!(self::ExtendedKalmanFilter)
  draw_covariance_ellipse!(self.belief.μ, self.belief.Σ, 3)
end