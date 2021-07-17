# module for evaluating agent's policy
# calculate state value function

using FreqTables, NamedArrays

include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/agent/puddle_ignore_agent.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/common/state_transition/state_transition.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))

mutable struct PolicyEvaluator
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

  # init
  function PolicyEvaluator(widths, goal,
                           puddles, 
                           delta_time,
                           sampling_num;
                           lower_left=[-4.0, -4.0],
                           upper_right=[4.0, 4.0])
    self = new()
    self.pose_min = [lower_left[1], lower_left[2], 0.0]
    self.pose_max = [upper_right[1], upper_right[2], 2*pi]
    self.widths = widths
    self.goal = goal

    self.index_nums = Tuple(get_index(self, self.pose_max))
    nx, ny, nt = self.index_nums[1], self.index_nums[2], self.index_nums[3]
    self.indexes = vec(collect(Base.product(1:nx, 1:ny, 1:nt)))
    self.value_function, self.is_final_state = init_value_function(self)
    self.policy = init_policy(self)

    actions_set = Set([Tuple(self.policy[i[1], i[2], i[3], :]) for i in self.indexes])
    self.actions = [a for a in actions_set]
    self.state_transition_probs = init_state_transition_probs(self, delta_time, sampling_num)
    
    self.depths = depth_means(self, puddles, sampling_num)

    return self
  end
end

function depth_means(self::PolicyEvaluator, puddles, sampling_num)
  # sampling
  dx = range(0, self.widths[1], length=sampling_num)
  dy = range(0, self.widths[2], length=sampling_num)
  samples = vec(collect(Base.product(dx, dy)))

  # mean of depth at each cell
  tmp = zeros(Tuple([self.index_nums[1], self.index_nums[2]]))
  for xy in collect(Base.product(1:self.index_nums[1], 1:self.index_nums[2]))
    for s in samples
      center = self.pose_min + self.widths.*[xy[1],xy[2], 0] + [s[1], s[2], 0]
      for p in puddles
        tmp[xy[1], xy[2]] += p.depth * inside(p, center)
      end
    end
    tmp[xy[1], xy[2]] /= sampling_num^2
  end

  return tmp
end

function init_state_transition_probs(self::PolicyEvaluator, delta_time, sampling_num)
  # sampling
  dx = range(0.001, self.widths[1]*0.999, length=sampling_num)
  dy = range(0.001, self.widths[2]*0.999, length=sampling_num)
  dt = range(0.001, self.widths[3]*0.999, length=sampling_num)
  samples = vec(collect(Base.product(dx, dy, dt)))
  
  # move sampled points and record delta index
  tmp = Dict()
  for a in self.actions
    for i_t in 1:self.index_nums[3]
      transition = []
      for s in samples
        # before transition
        before_pose = [s[1], s[2], s[3] + i_t*self.widths[3]] + self.pose_min
        before_index = [0, 0, i_t]

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
      tmp[a, i_t] = [[d, p] for (d, p) in zip(diffs, probs)]
    end
  end

  return tmp
end

function get_index(self::PolicyEvaluator, pose)
  return Int64.(floor.((pose - self.pose_min)./self.widths)) + [1, 1, 1]
end

function init_policy(self::PolicyEvaluator)
  tmp = zeros(Tuple([self.index_nums[1], self.index_nums[2], self.index_nums[3], 2]))

  for index in self.indexes
    center = self.pose_min + self.widths.*(index .+ 0.5)
    tmp[index[1], index[2], index[3], :] .= policy(center, self.goal)
  end

  return tmp
end

function init_value_function(self::PolicyEvaluator)
  v = Array{Float64}(undef, self.index_nums)
  f = zeros(self.index_nums)

  for index in self.indexes 
    f[index[1], index[2], index[3]] = final_state(self, index)
    if f[index[1], index[2], index[3]] == true
      v[index[1], index[2], index[3]] = self.goal.value
    else
      v[index[1], index[2], index[3]] = -100.0
    end
  end

  return v, f
end

function final_state(self::PolicyEvaluator, index)
  lower_left = self.pose_min + self.widths.*index
  upper_right = self.pose_min + self.widths.*(index.+1)
  
  corners = [[lower_left[1], lower_left[2]], 
             [lower_left[1], upper_right[2]],
             [upper_right[1], lower_left[2]],
             [upper_right[1], upper_right[2]]]
  
  # check arrived at goal
  # all of corner point should be inside of goal area
  result = true
  for c in corners
    if inside(self.goal, c) == false
      result = false
    end
  end

  return result
end