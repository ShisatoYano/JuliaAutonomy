# module for storing q value at each state

using Random
using StatsBase

mutable struct StateInfo
  q
  epsilon

  # init
  function StateInfo(action_num=0; epsilon=0.3)
    self = new()

    self.q = zeros(action_num)
    self.epsilon = epsilon

    return self
  end
end

# get index of action which has maximum q value
# greedy policy
function greedy(self::StateInfo)
  return argmax(self.q)
end

# select another action following probability epsilon
function epsilon_greedy(self::StateInfo)
  if rand(1)[1] < self.epsilon
    return rand(1:length(self.q), 1)[1]
  else
    return greedy(self)
  end
end

# call greedy()
function _pi(self::StateInfo)
  return epsilon_greedy(self)
end