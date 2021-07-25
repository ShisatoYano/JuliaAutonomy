# module for storing q value at each state

mutable struct StateInfo
  q

  # init
  function StateInfo(action_num=0)
    self = new()

    self.q = zeros(action_num)

    return self
  end
end

# get index of action which has maximum q value
# greedy policy
function greedy(self::StateInfo)
  return argmax(self.q)
end

# call greedy()
function pi(self::StateInfo)
  return greedy(self)
end