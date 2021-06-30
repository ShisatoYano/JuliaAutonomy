# module for representing observation edge

mutable struct ObsrvEdge
  t1
  t2
  z1
  z2
  x1
  x2

  # init
  function ObsrvEdge(t1, t2, z1, z2, pose_list)
    @assert z1[1] == z2[1] # prevent id is different

    self = new()
    self.t1 = t1 # time
    self.t2 = t2
    self.z1 = z1 # observation
    self.z2 = z2
    self.x1 = pose_list[string(t1)] # pose
    self.x2 = pose_list[string(t2)]
    return self
  end
end