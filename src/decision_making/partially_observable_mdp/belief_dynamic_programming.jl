# module for optimizing policy
# by value iteration
# considering belief distribution get narrow

using FreqTables, NamedArrays, LinearAlgebra

include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/agent/puddle_ignore_agent.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/state_transition/state_transition.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/localization/extended_kalman_filter/extended_kalman_filter.jl"))

mutable struct BeliefDynamicProgramming
  pose_min
  pose_max
  widths
  goal
  index_nums
  indexes
  value_function
  is_final_state
  policy
  actions
  state_transition_probs
  depths
  delta_time
  puddle_coef
  dev_borders
  dev_borders_side
  motion_sigma_transition_probs

  # init
  function BeliefDynamicProgramming(widths, goal,
                                    puddles, 
                                    delta_time,
                                    sampling_num;
                                    puddle_coef=100,
                                    lower_left=[-4.0, -4.0],
                                    upper_right=[4.0, 4.0],
                                    dev_borders=[0.1, 0.2, 0.4, 0.8])
    self = new()
    self.pose_min = [lower_left[1], lower_left[2], 0.0]
    self.pose_max = [upper_right[1], upper_right[2], 2*pi]
    self.widths = widths
    self.goal = goal

    index_nums_3d = round.(Int64, (self.pose_max - self.pose_min)./self.widths)
    self.index_nums = [index_nums_3d[1], index_nums_3d[2], index_nums_3d[3], length(dev_borders)]
    nx, ny, nt, nh = self.index_nums[1], self.index_nums[2], self.index_nums[3] , self.index_nums[4]
    self.indexes = vec(collect(Base.product(0:nx-1, 0:ny-1, 0:nt-1, 0:nh-1)))
    self.value_function, self.is_final_state = init_belief_value_function(self)
    self.policy = init_policy(self)

    actions_set = Set([Tuple(self.policy[i[1]+1, i[2]+1, i[3]+1, :]) for i in self.indexes])
    self.actions = [a for a in actions_set]
    self.state_transition_probs = init_state_transition_probs(self, delta_time, sampling_num)
    
    self.depths = depth_means(self, puddles, sampling_num)

    self.delta_time = delta_time
    self.puddle_coef = puddle_coef

    self.dev_borders = dev_borders
    self.dev_borders_side = [dev_borders[1]/10, dev_borders[1], dev_borders[2], dev_borders[3], dev_borders[4], dev_borders[4]*10]
    self.motion_sigma_transition_probs = init_motion_sigma_transition_probs(self)

    return self
  end
end

function depth_means(self::BeliefDynamicProgramming, puddles, sampling_num)
  # sampling
  dx = range(0, self.widths[1], length=sampling_num)
  dy = range(0, self.widths[2], length=sampling_num)
  samples = vec(collect(Base.product(dx, dy)))

  # mean of depth at each cell
  tmp = zeros(Tuple([self.index_nums[1], self.index_nums[2]]))
  for xy in collect(Base.product(0:self.index_nums[1]-1, 0:self.index_nums[2]-1))
    for s in samples
      center = self.pose_min + self.widths.*[xy[1], xy[2], 0] + [s[1], s[2], 0]
      for p in puddles
        tmp[xy[1]+1, xy[2]+1] += p.depth * inside(p, center)
      end
    end
    tmp[xy[1]+1, xy[2]+1] /= sampling_num^2
  end

  return tmp
end

function init_motion_sigma_transition_probs(self::BeliefDynamicProgramming)
  probs = Dict()

  for a in self.actions
    for i in 0:length(self.dev_borders)
      probs[i, a] = calc_motion_sigma_transition_probs(self,
                                                       self.dev_borders_side[i+1],
                                                       self.dev_borders_side[i+2],
                                                       a)
    end
  end

  return probs
end

function cov_to_index(self::BeliefDynamicProgramming, cov)
  sigma = det(cov)^(1.0/6)
  
  for (i, e) in enumerate(self.dev_borders)
    if sigma < e
      return i-1
    end
  end

  return length(self.dev_borders)
end

function calc_motion_sigma_transition_probs(self::BeliefDynamicProgramming,
                                            min_sigma, max_sigma, action;
                                            sampling_num=100)
  speed, yaw_rate = action[1], action[2]
  if abs(yaw_rate) < 1e-5
    yaw_rate = 1e-5
  end

  F = mat_F(speed, yaw_rate, self.delta_time, 0.0)
  M = mat_M(speed, yaw_rate, self.delta_time, Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20))
  A = mat_A(speed, yaw_rate, self.delta_time, 0.0)

  ans = Dict()
  for sigma in range(min_sigma, max_sigma*0.999, length=sampling_num)
    index_after = cov_to_index(self, (sigma^2).*F*F+A*M*A')
    if haskey(ans, index_after) == false
      ans[index_after] = 1
    else
      ans[index_after] += 1
    end
  end

  # convert from frequency to probability
  for e in ans
    ans[e[1]] /= sampling_num
  end

  return ans
end

function init_state_transition_probs(self::BeliefDynamicProgramming, delta_time, sampling_num)
  # sampling
  dx = range(0.001, self.widths[1]*0.999, length=sampling_num)
  dy = range(0.001, self.widths[2]*0.999, length=sampling_num)
  dt = range(0.001, self.widths[3]*0.999, length=sampling_num)
  samples = vec(collect(Base.product(dx, dy, dt)))
  
  # move sampled points and record delta index
  tmp = Dict()
  for a in self.actions
    for i_t in 0:self.index_nums[3]-1
      transition = []
      for s in samples
        # before transition
        before_pose = [s[1], s[2], s[3] + i_t*self.widths[3]] + self.pose_min
        before_index = [1, 1, i_t+1]

        # after transition
        after_pose = state_transition(a[1], a[2], delta_time, before_pose)
        after_index = get_index(self, after_pose)
        
        # index difference
        push!(transition, after_index-before_index)
      end
      # frequency of each index difference
      freq_tbl = freqtable(transition)
      freqs = [value for (name, value) in enumerate(freq_tbl)]
      diffs = [diff for diff in names(freq_tbl, 1)]
      
      # probability
      probs = freqs ./ sampling_num^3
      tmp[a, i_t+1] = [[d, p] for (d, p) in zip(diffs, probs)]
    end
  end

  return tmp
end

function get_index(self::BeliefDynamicProgramming, pose)
  return Int64.(floor.((pose - self.pose_min)./self.widths))
end

function init_policy(self::BeliefDynamicProgramming)
  tmp = zeros(Tuple([self.index_nums[1], self.index_nums[2], self.index_nums[3], 2]))

  for index in self.indexes
    center = self.pose_min + self.widths.*(index[1:3] .+ 0.5)
    tmp[index[1]+1, index[2]+1, index[3]+1, :] .= policy(center, self.goal)
  end

  return tmp
end

function init_belief_value_function(self::BeliefDynamicProgramming)
  v = Array{Float64}(undef, Tuple(self.index_nums))
  f = zeros(Tuple(self.index_nums))

  for index in self.indexes 
    f[index[1]+1, index[2]+1, index[3]+1, index[4]+1] = belief_final_state(self, index)
    if f[index[1]+1, index[2]+1, index[3]+1, index[4]+1] == true
      v[index[1]+1, index[2]+1, index[3]+1, index[4]+1] = self.goal.value
    else
      v[index[1]+1, index[2]+1, index[3]+1, index[4]+1] = -100.0
    end
  end

  return v, f
end

function belief_final_state(self::BeliefDynamicProgramming, index)
  lower_left = self.pose_min + self.widths.*index[1:3]
  upper_right = self.pose_min + self.widths.*(index[1:3].+1)
  
  corners = [[lower_left[1], lower_left[2]], 
             [lower_left[1], upper_right[2]],
             [upper_right[1], lower_left[2]],
             [upper_right[1], upper_right[2]]]
  
  # check arrived at goal
  # all of corner point should be inside of goal area
  for c in corners
    if inside(self.goal, c) == false
      return false
    end
  end

  # only when belief distribution is narrow,
  # decided robot reached at goal
  if index[4] != 0
    return false
  end

  return true
end

# give penalty when robot moved out of space
# and then, return state inside space
function out_correction(self::BeliefDynamicProgramming, index)
  out_reward = 0.0

  # direction
  index[3] = (index[3] + self.index_nums[3])%self.index_nums[3]

  for i in 1:2
    if index[i] < 0
      index[i] = 0
      out_reward = -1e100
    elseif index[i] >= self.index_nums[i]
      index[i] = self.index_nums[i] - 1
      out_reward = -1e100
    end
  end
  
  return index, out_reward
end

function action_value(self::BeliefDynamicProgramming, action, index; out_penalty=true)
  value = 0.0

  for delta_prob in self.state_transition_probs[(action, index[3]+1)]
    after, out_reward = out_correction(self, [index[1]+1, index[2]+1, index[3]+1]+delta_prob[1])
    reward = -self.delta_time*self.depths[after[1]+1, after[2]+1]*self.puddle_coef - self.delta_time + out_reward*out_penalty
    
    for sigma_after_prob in self.motion_sigma_transition_probs[(index[4]+1, action)]
      value += (self.value_function[after[1]+1, after[2]+1, after[3]+1, sigma_after_prob[1]] + reward) * delta_prob[2] * sigma_after_prob[2]
    end
  end

  return value
end

function policy_evaluation_sweep(self::BeliefDynamicProgramming)
  max_delta = 0.0
  
  for i in self.indexes
    if self.is_final_state[i[1]+1, i[2]+1, i[3]+1] != true
      q = action_value(self, Tuple(self.policy[i[1]+1, i[2]+1, i[3]+1, :]), i)
      
      delta = abs(self.value_function[i[1]+1, i[2]+1, i[3]+1] - q)

      if delta > max_delta
        max_delta = delta
      else
        max_delta = max_delta
      end

      self.value_function[i[1]+1, i[2]+1, i[3]+1] = q
    end
  end

  return max_delta
end

function value_iteration_sweep(self::BeliefDynamicProgramming)
  max_delta = 0.0
  
  for i in self.indexes
    if self.is_final_state[i[1]+1, i[2]+1, i[3]+1, i[4]+1] != true
      max_q = -1e100
      max_a = nothing

      qs = [action_value(self, a, i) for a in self.actions]
      max_q = findmax(qs)[1]
      max_a = self.actions[argmax(qs)]
      
      delta = abs(self.value_function[i[1]+1, i[2]+1, i[3]+1, i[4]+1] - max_q)
      if delta > max_delta
        max_delta = delta
      else
        max_delta = max_delta
      end

      self.value_function[i[1]+1, i[2]+1, i[3]+1, i[4]+1] = max_q
      self.policy[i[1]+1, i[2]+1, i[3]+1, :] .= max_a
    end
  end

  return max_delta
end