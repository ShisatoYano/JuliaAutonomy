# module for evaluating agent's policy
# calculate state value function

mutable struct PolicyEvaluator
  pose_min
  pose_max
  widths
  index_nums

  # init
  function PolicyEvaluator(widths;
                           lower_left=[-4.0, -4.0],
                           upper_right=[4.0, 4.0])
    self = new()
    self.pose_min = [lower_left[1], lower_left[2], 0.0]
    self.pose_max = [upper_right[1], upper_right[2], 2*pi]
    self.widths = widths
    self.index_nums = round.(Int64, (self.pose_max - self.pose_min)./self.widths)
    return self
  end
end