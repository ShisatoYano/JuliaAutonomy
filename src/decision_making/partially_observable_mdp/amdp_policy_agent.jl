# module for representing agent
# decide control order to robot
# get action based on policy
# by dynamic programming
# using augmented mdp(amdp)

mutable struct AmdpPolicyAgent
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
  pose_min
  pose_max
  widths
  index_nums
  dev_borders
  policy_data
  stop_timer

  # init
  function AmdpPolicyAgent(;delta_time::Float64=0.1,
                           estimator=nothing,
                           goal=nothing,
                           puddle_coef=100,
                           widths=[0.2, 0.2, pi/18],
                           lower_left=[-4.0, -4.0],
                           upper_right=[4.0, 4.0],
                           dev_borders=[0.1, 0.2, 0.4, 0.8])
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

    self.pose_min = [lower_left[1], lower_left[2], 0.0]
    self.pose_max = [upper_right[1], upper_right[2], 2*pi]
    self.widths = widths
    index_nums_3d = round.(Int64, (self.pose_max - self.pose_min)./self.widths)
    self.index_nums = [index_nums_3d[1], index_nums_3d[2], index_nums_3d[3], length(dev_borders)]
    self.dev_borders = dev_borders
    self.policy_data = init_belief_policy(self)
    self.stop_timer = 0.0
    
    return self
  end
end

function init_belief_policy(self::AmdpPolicyAgent)
  tmp = zeros(Tuple([self.index_nums[1], self.index_nums[2], self.index_nums[3], self.index_nums[4], 2]))

  txt_path = "src/decision_making/partially_observable_mdp/policy_amdp.txt"
  open(joinpath(split(@__FILE__, "src")[1], txt_path), "r") do fp
    for line in eachline(fp)
      d = split(line) # [i_x, i_y, i_theta, i_sigma, speed, yaw_rate]
      tmp[parse(Int64, d[1])+1, parse(Int64, d[2])+1, parse(Int64, d[3])+1, parse(Int64, d[4])+1, :] .= [parse(Float64, d[5]), parse(Float64, d[6])]
    end
  end

  return tmp
end

function cov_to_index(self::AmdpPolicyAgent, cov)
  sigma = det(cov)^(1.0/6)
  
  for (i, e) in enumerate(self.dev_borders)
    if sigma < e
      return i-1
    end
  end

  return length(self.dev_borders)-1
end

function reward_per_sec(self::AmdpPolicyAgent)
  return (-1.0 - self.puddle_depth*self.puddle_coef)
end

function to_index(self::AmdpPolicyAgent, pose)
  index = Int64.(floor.((pose - self.pose_min)./self.widths))

  # normalize direction index
  index[3] = (index[3] + self.index_nums[3]*1000)%self.index_nums[3]

  for i in 1:2
    if index[i] < 0
      index[i] = 0
    elseif index[i] >= self.index_nums[i]
      index[i] = self.index_nums[i] - 1
    end
  end

  return index
end

function policy(self::AmdpPolicyAgent, pose, cov)
  pose_index = to_index(self, pose)
  belief_index = cov_to_index(self, cov)

  action = self.policy_data[pose_index[1]+1, pose_index[2]+1, pose_index[3]+1, belief_index+1, :]

  # if action[1] == 0.0
  #   self.stop_timer += self.delta_time
  # else
  #   self.stop_timer = 0.0
  # end

  # if self.stop_timer > 2.0
  #   return -1.0, 0.0
  # end

  return action[1], action[2] 
end

function draw_decision!(self::AmdpPolicyAgent, observation)
  # reached goal
  if self.in_goal == true
    return 0.0, 0.0 # stop
  end

  if self.estimator !== nothing
    motion_update(self.estimator, self.prev_spd, self.prev_yr, self.delta_time)
    observation_update(self.estimator, observation)

    self.total_reward += self.delta_time * reward_per_sec(self)

    self.speed, self.yaw_rate = policy(self, self.estimator.estimated_pose, self.estimator.estimated_cov)
    self.prev_spd, self.prev_yr = self.speed, self.yaw_rate

    draw!(self.estimator)
  end

  return self.speed, self.yaw_rate
end