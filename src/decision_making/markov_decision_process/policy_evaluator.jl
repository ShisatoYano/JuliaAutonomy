# module for evaluating agent's policy
# calculate state value function

include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))

mutable struct PolicyEvaluator
  pose_min
  pose_max
  widths
  goal
  index_nums
  indexes
  value_function
  is_final_state

  # init
  function PolicyEvaluator(widths, goal;
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
    return self
  end
end

function get_index(self::PolicyEvaluator, pose)
  return Int64.(floor.((pose - self.pose_min)./self.widths)) + [1, 1, 1]
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