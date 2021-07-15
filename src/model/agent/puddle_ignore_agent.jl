# module for representing agent
# decide control order to robot
# this agent ignore puddle

mutable struct PuddleIgnoreAgent
  speed
  yaw_rate
  delta_time
  estimator
  prev_spd
  prev_yr
  puddle_coef
  puddle_depth
  total_reward

  # init
  function PuddleIgnoreAgent(speed::Float64, yaw_rate::Float64;
                             delta_time::Float64=0.1,
                             estimator=nothing,
                             puddle_coef=100)
      self = new()
      self.speed = speed
      self.yaw_rate = yaw_rate
      self.delta_time = delta_time
      self.estimator = estimator
      self.prev_spd = 0.0
      self.prev_yr = 0.0
      self.puddle_coef = puddle_coef
      self.puddle_depth = 0.0
      self.total_reward = 0.0
      return self
  end
end

function reward_per_sec(self::PuddleIgnoreAgent)
  return (-1.0 - self.puddle_depth*self.puddle_coef)
end

function draw_decision!(self::PuddleIgnoreAgent, observation)
  if self.estimator !== nothing
      motion_update(self.estimator, self.prev_spd, self.prev_yr, self.delta_time)
      self.prev_spd, self.prev_yr = self.speed, self.yaw_rate
      observation_update(self.estimator, observation)

      self.total_reward += self.delta_time * reward_per_sec(self)

      draw!(self.estimator)
  end
  return self.speed, self.yaw_rate
end