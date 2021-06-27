# module for sensing object and drawing observation

using Plots, Random, Distributions
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/observation_function/observation_function.jl"))

mutable struct PsiSensor
  map
  last_data
  dist_rng
  dir_rng
  dist_noise_rate
  dir_noise # std dev
  dist_bias_rate_std
  dir_bias
  phantom_dist_x
  phantom_dist_y
  phantom_prob
  oversight_prob
  occlusion_prob

  # init
  function PsiSensor(map::Map;
                     dist_rng::Tuple=(0.5, 6.0), 
                     dir_rng::Tuple=(-pi/3, pi/3),
                     dist_noise_rate=0.0,
                     dir_noise=0.0,
                     dist_bias_rate_stddev=0.0,
                     dir_bias_stddev=0.0,
                     phantom_prob=0.0,
                     phantom_rng_x::Tuple=(-5.0, 5.0),
                     phantom_rng_y::Tuple=(-5.0, 5.0),
                     oversight_prob=0.0,
                     occlusion_prob=0.0)
    self = new()
    self.map = map
    self.last_data = []
    self.dist_rng = dist_rng
    self.dir_rng = dir_rng
    self.dist_noise_rate = dist_noise_rate
    self.dir_noise = dir_noise
    self.dist_bias_rate_std = rand(Normal(0.0, dist_bias_rate_stddev))
    self.dir_bias = rand(Normal(0.0, dir_bias_stddev))
    rx = phantom_rng_x
    ry = phantom_rng_y
    self.phantom_dist_x = Uniform(rx[1], rx[2])
    self.phantom_dist_y = Uniform(ry[1], ry[2])
    self.phantom_prob = phantom_prob
    self.oversight_prob = oversight_prob
    self.occlusion_prob = occlusion_prob
    return self
  end
end

function visible(self::PsiSensor, obsrv=nothing)
  if obsrv === nothing
    return false
  end

  return ((self.dist_rng[1] <= obsrv[1] <= self.dist_rng[2])
    && (self.dir_rng[1] <= obsrv[2] <= self.dir_rng[2]))
end

function noise(self::PsiSensor, obsrv::Array)
  ell = rand(Normal(obsrv[1], obsrv[1] * self.dist_noise_rate))
  phi = rand(Normal(obsrv[2], self.dir_noise))
  return [ell, phi]
end

function bias(self::PsiSensor, obsrv::Array)
  return obsrv + [obsrv[1] * self.dist_bias_rate_std, self.dir_bias]
end

function phantom(self::PsiSensor, sns_pose::Array, obsrv::Array)
  if rand(Uniform()) < self.phantom_prob
    phantom_pose = [rand(self.phantom_dist_x), rand(self.phantom_dist_y)]
    return observation_function(sns_pose, phantom_pose)
  else
      return obsrv
  end
end

function oversight(self::PsiSensor, obsrv::Array)
  if rand(Uniform()) < self.oversight_prob
    return nothing
  else
    return obsrv
  end
end

function occlusion(self::PsiSensor, obsrv::Array)
  if rand(Uniform()) < self.occlusion_prob
    ell = obsrv[1] - rand(Uniform()) * (self.dist_rng[2] - obsrv[1])
    phi = obsrv[2]
    return [ell, phi]
  else
    return obsrv
  end
end

function data(self::PsiSensor, sns_pose::Array; orient_noise=pi/90)
  observed = []
  for obj in self.map.objects
    # calculate orientation
    diff_x = sns_pose[1] - obj.pose[1]
    diff_y = sns_pose[2] - obj.pose[2]
    psi = rand(Normal(atan(diff_y, diff_x), orient_noise))

    # calculate observation
    obsrv = observation_function(sns_pose, obj.pose)
    
    # add disturbance
    obsrv = phantom(self, sns_pose, obsrv)
    obsrv = occlusion(self, obsrv)
    obsrv = oversight(self, obsrv)
    if visible(self, obsrv)
      obsrv = bias(self, obsrv)
      obsrv = noise(self, obsrv)
      push!(observed, ([obsrv[1], obsrv[2], psi], obj.id))
    end
  end
  self.last_data = observed
end

function draw!(self::PsiSensor, sns_pose::Array)
  for obj in self.last_data
    x, y, theta = sns_pose[1], sns_pose[2], sns_pose[3]
    distance, direction = obj[1][1], obj[1][2]
    ox = x + distance * cos(direction + theta)
    oy = y + distance * sin(direction + theta)
    plot!([x, ox], [y, oy], color="pink",
          legend=false, aspect_ratio=true)
  end
end