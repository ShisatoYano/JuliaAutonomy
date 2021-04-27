# class for representing particle

mutable struct Particle
  pose

  # init
  function Particle(init_pose::Array)
    self = new()
    self.pose = init_pose
    return self
  end
end