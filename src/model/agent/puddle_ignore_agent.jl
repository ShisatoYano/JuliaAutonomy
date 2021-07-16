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
  in_goal
  final_value
  goal

  # init
  function PuddleIgnoreAgent(;delta_time::Float64=0.1,
                             estimator=nothing,
                             goal=nothing,
                             puddle_coef=100)
    self = new()
    self.speed = 0.0
    self.yaw_rate = 0.0
    self.delta_time = delta_time
    self.estimator = estimator
    self.prev_spd = 0.0
    self.prev_yr = 0.0
    self.puddle_coef = puddle_coef
    self.puddle_depth = 0.0
    self.total_reward = 0.0
    self.in_goal = false
    self.final_value = 0.0
    self.goal = goal
    return self
  end
end

function reward_per_sec(self::PuddleIgnoreAgent)
  return (-1.0 - self.puddle_depth*self.puddle_coef)
end

function policy(pose, goal)
  x, y, theta = pose[1], pose[2], pose[3]
  dx, dy = goal.pose[1]-x, goal.pose[2]-y
  direction = Int64(round((atan(dy, dx) - theta) * 180 / pi))
  direction = (direction + 360*1000 + 180)%360 - 180 # normalize -180 ~ 180 [deg]
  
  if direction > 10
    speed, yaw_rate = 0.0, 2.0
  elseif direction < -10
    speed, yaw_rate = 0.0, -2.0
  else
    speed, yaw_rate = 1.0, 0.0
  end

  return speed, yaw_rate
end

function draw_decision!(self::PuddleIgnoreAgent, observation)
  # reached goal
  if self.in_goal == true
    return 0.0, 0.0 # stop
  end

  if self.estimator !== nothing
    motion_update(self.estimator, self.prev_spd, self.prev_yr, self.delta_time)
    observation_update(self.estimator, observation)

    self.total_reward += self.delta_time * reward_per_sec(self)

    self.speed, self.yaw_rate = policy(self.estimator.estimated_pose, self.goal)
    self.prev_spd, self.prev_yr = self.speed, self.yaw_rate

    draw!(self.estimator)
    x = self.estimator.estimated_pose[1]
    y = self.estimator.estimated_pose[2]
    annotate!(x+1.0, y-0.5, text("reward/sec:$(reward_per_sec(self))", :left, 8))
    annotate!(x+1.0, y-1.0, text("total reward:$(round(self.total_reward, digits=1))", :left, 8))
  end

  return self.speed, self.yaw_rate
end