# module for representing agent
# decide control order to robot
# get action based on policy
# by n-step sarsa

include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/reinforcement_learning/state_info.jl"))

mutable struct NstepSarsaAgent
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
  stuck_timer
  learning_timer

  # for n-step sarsa
  s_trace
  a_trace
  r_trace
  n_step

  # init
  function NstepSarsaAgent(;delta_time::Float64=0.1,
                           estimator=nothing,
                           puddle_coef=100,
                           alpha=0.5,
                           widths=[0.2, 0.2, pi/18],
                           lower_left=[-4.0, -4.0],
                           upper_right=[4.0, 4.0],
                           dev_borders=[0.1, 0.2, 0.4, 0.8],
                           n_step=10)
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
    self.stuck_timer = 0.0
    self.learning_timer = 0.0

    self.s_trace = []
    self.a_trace = []
    self.r_trace = []
    self.n_step = n_step
    return self
  end
end

function set_action_value_function(self::NstepSarsaAgent)
  state_space = Dict()

  txt_path = "src/decision_making/reinforcement_learning/value.txt"
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

function init_policy(self::NstepSarsaAgent)
  tmp = zeros(Tuple([self.index_nums[1], self.index_nums[2], self.index_nums[3], 2]))

  txt_path = "src/decision_making/reinforcement_learning/policy.txt"
  open(joinpath(split(@__FILE__, "src")[1], txt_path), "r") do fp
    for line in eachline(fp)
      d = split(line) # [i_x, i_y, i_theta, speed, yaw_rate]
      tmp[parse(Int64, d[1])+1, parse(Int64, d[2])+1, parse(Int64, d[3])+1, :] .= [parse(Float64, d[4]), parse(Float64, d[5])]
    end
  end

  return tmp
end

function reward_per_sec(self::NstepSarsaAgent)
  return (-1.0 - self.puddle_depth*self.puddle_coef)
end

function to_index(self::NstepSarsaAgent, pose)
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

function policy(self::NstepSarsaAgent, pose)
  index = to_index(self, pose)

  s = Tuple(index .+ [1, 1, 1])

  a = _pi(self.state_space[s])

  return s, a 
end

function q_update(self::NstepSarsaAgent, s_, a_, n)
  if n > length(self.s_trace) || n == 0
    return # num of stored steps is not enough 
  end

  # state and action before n steps
  s, a = self.s_trace[end-(n-1)], self.a_trace[end-(n-1)]

  # q before update
  q = self.state_space[s].q[a]

  # total reward during n steps
  r = sum(self.r_trace[(end-(n-1)):end])
  
  # q after state transition
  if self.in_goal == true
    q_ = self.final_value
  else
    q_ = self.state_space[s_].q[a_] # next state and action
  end

  # update q
  self.state_space[s].q[a] = (1.0 - self.alpha)*q + self.alpha*(r + q_)

  # when reached at goal, update q from 1 ~ n-1 step
  if self.in_goal == true
    q_update(self, s_, a_, n-1)
  end
end

function draw_decision!(self::NstepSarsaAgent, observation)
  # finished learning
  if self.update_end == true
    return 0.0, 0.0 # stop
  end

  # reached at goal
  if self.in_goal == true
    self.update_end = true
  end

  # time limit learning
  if self.learning_timer > 60.0 && self.in_goal == false
    self.update_end = true
  end

  if self.estimator !== nothing
    # state estimation
    motion_update(self.estimator, self.prev_spd, self.prev_yr, self.delta_time)
    observation_update(self.estimator, observation)

    # decide next action
    s_, a_ = policy(self, self.estimator.estimated_pose)

    # calculate reward for state transition
    r = self.delta_time * reward_per_sec(self)
    push!(self.r_trace, r)
    self.total_reward += r

    # q-learning
    q_update(self, s_, a_, self.n_step) # update using reward and next state
    push!(self.s_trace, s_)
    push!(self.a_trace, a_)

    # output speed and yaw rate
    self.speed, self.yaw_rate = self.actions[a_][1], self.actions[a_][2]
    self.prev_spd, self.prev_yr = self.speed, self.yaw_rate

    draw!(self.estimator)
    x = self.estimator.estimated_pose[1]
    y = self.estimator.estimated_pose[2]
    annotate!(x+1.0, y-0.5, text("reward/sec:$(reward_per_sec(self))", :left, 8))
    annotate!(x+1.0, y-1.0, text("total reward:$(round(self.total_reward, digits=1))", :left, 8))
    
    self.learning_timer += self.delta_time
  end

  return self.speed, self.yaw_rate
end