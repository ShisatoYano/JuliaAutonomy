# module for representing agent
# decide control order to robot
# log pose and observation into text file

mutable struct LoggerAgent
  speed
  yaw_rate
  time_interval
  estimator
  prev_spd
  prev_yr
  pose
  step
  log

  # init
  function LoggerAgent(speed::Float64, yaw_rate::Float64;
                       time_interval::Float64=0.1,
                       estimator=nothing,
                       init_pose=[0.0, 0.0, 0.0])
      self = new()
      self.speed = speed
      self.yaw_rate = yaw_rate
      self.time_interval = time_interval
      self.estimator = estimator
      self.prev_spd = 0.0
      self.prev_yr = 0.0
      self.pose = init_pose
      self.step = 0
      return self
  end
end

function draw_decision!(self::Agent, observation)
  if self.estimator !== nothing
      motion_update(self.estimator, self.prev_spd, self.prev_yr, self.time_interval)
      self.prev_spd, self.prev_yr = self.speed, self.yaw_rate
      observation_update(self.estimator, observation)
      draw!(self.estimator)
  end
  return self.speed, self.yaw_rate
end