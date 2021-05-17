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

function motion_update(self::ExtendedKalmanFilter, speed, 
                       yaw_rate, time_interval)
  
end

function observation_update(self::ExtendedKalmanFilter, observation)
  
end

function draw!(self::ExtendedKalmanFilter)
  draw_covariance_ellipse!(self.belief.μ, self.belief.Σ, 3)
end