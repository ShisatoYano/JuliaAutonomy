# module for representing agent
# decide control order to robot
# get action based on policy
# by q learning

include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/reinforcement_learning/q_learning/state_info.jl"))

mutable struct QAgent
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
  indexes
  actions
  policy_data
  state_space
  
  # for reinforcement learning
  alpha # step size parameter
  s # state
  a # action
  update_end # end flag

  # init
  function QAgent(;delta_time::Float64=0.1,
                  estimator=nothing,
                  puddle_coef=100,
                  alpha=0.5,
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
    self.goal = nothing

    self.pose_min = [lower_left[1], lower_left[2], 0.0]
    self.pose_max = [upper_right[1], upper_right[2], 2*pi]
    self.widths = widths
    self.index_nums = round.(Int64, (self.pose_max - self.pose_min)./self.widths)
    self.policy_data = init_policy(self)

    nx, ny, nt = self.index_nums[1], self.index_nums[2], self.index_nums[3]
    self.indexes = vec(collect(Base.product(0:nx-1, 0:ny-1, 0:nt-1)))
    actions_set = Set([Tuple(self.policy_data[i[1]+1, i[2]+1, i[3]+1, :]) for i in self.indexes])
    self.actions = [a for a in actions_set]
    self.state_space = set_action_value_function(self)

    self.alpha = alpha
    self.s = nothing
    self.a = nothing
    self.update_end = false
    return self
  end
end

function set_action_value_function(self::QAgent)
  state_space = Dict()

  txt_path = "src/decision_making/reinforcement_learning/q_learning/value.txt"
  open(joinpath(split(@__FILE__, "src")[1], txt_path), "r") do fp
    for line in eachline(fp)
      d = split(line) # [i_x, i_y, i_theta, value]
      index, value = Tuple([parse(Int64, d[1])+1, parse(Int64, d[2])+1, parse(Int64, d[3])+1]), parse(Float64, d[4])
      state_space[index] = StateInfo(length(self.actions))

      for (i, a) in enumerate(self.actions)
        if Tuple(self.policy_data[index[1], index[2], index[3], :]) == a
          state_space[index].q[i] = value
        else
          state_space[index].q[i] = value - 0.1
        end
      end
    end
  end

  return state_space
end

function init_policy(self::QAgent)
  tmp = zeros(Tuple([self.index_nums[1], self.index_nums[2], self.index_nums[3], 2]))

  txt_path = "src/decision_making/reinforcement_learning/q_learning/policy.txt"
  open(joinpath(split(@__FILE__, "src")[1], txt_path), "r") do fp
    for line in eachline(fp)
      d = split(line) # [i_x, i_y, i_theta, speed, yaw_rate]
      tmp[parse(Int64, d[1])+1, parse(Int64, d[2])+1, parse(Int64, d[3])+1, :] .= [parse(Float64, d[4]), parse(Float64, d[5])]
    end
  end

  return tmp
end

function reward_per_sec(self::QAgent)
  return (-1.0 - self.puddle_depth*self.puddle_coef)
end

function to_index(self::QAgent, pose)
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

function policy(self::QAgent, pose)
  index = to_index(self, pose)

  s = Tuple(index .+ [1, 1, 1])

  a = _pi(self.state_space[s])

  return s, a 
end

function draw_decision!(self::QAgent, observation)
  # reached goal
  if self.in_goal == true
    return 0.0, 0.0 # stop
  end

  if self.estimator !== nothing
    motion_update(self.estimator, self.prev_spd, self.prev_yr, self.delta_time)
    observation_update(self.estimator, observation)

    self.total_reward += self.delta_time * reward_per_sec(self)

    self.speed, self.yaw_rate = policy(self, self.estimator.estimated_pose)
    self.prev_spd, self.prev_yr = self.speed, self.yaw_rate

    draw!(self.estimator)
  end

  return self.speed, self.yaw_rate
end