# module for representing agent
# decide control order to robot
# log pose and observation into text file

include(joinpath(split(@__FILE__, "src")[1], "src/common/state_transition/state_transition.jl"))

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
      log_path = "src/slam/graph_based_slam/traj_obsrv_log.txt"
      self.log = open(joinpath(split(@__FILE__, "src")[1], log_path), "w")
      return self
  end
end

function close_log_file(self::LoggerAgent)
  close(self.log)
end

function draw_decision!(self::LoggerAgent, observation)
  # logging trajectory and observation
  if length(observation) > 0
    write(self.log, "x $(self.step) $(self.pose[1]) $(self.pose[2]) $(self.pose[3])\n") # step x y theta
    for obs in observation
      write(self.log, "z $(self.step) $(obs[2]) $(obs[1][1]) $(obs[1][2]) $(obs[1][3])\n") # step id distance direction orientation
    end
    self.step += 1
  end

  # draw estimated pose
  if self.estimator !== nothing
    motion_update(self.estimator, self.prev_spd, self.prev_yr, self.time_interval)
    self.prev_spd, self.prev_yr = self.speed, self.yaw_rate
    observation_update(self.estimator, observation)
    draw!(self.estimator)
  end

  self.pose = state_transition(self.speed, self.yaw_rate, self.time_interval, self.pose)
  return self.speed, self.yaw_rate
end