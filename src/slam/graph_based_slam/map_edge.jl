# module for landmark estimation by graph based slam

mutable struct MapEdge
  x
  z
  m

  # init
  # head_t: time when target landmark was observed for the first time
  # head_z: observed values when target landmark was observed for the first time
  function MapEdge(t, z, head_t, head_z, pose_list)
    self = new()
    self.x = pose_list[string(t)]
    self.z = z

    # landmark's pose
    delta_obsrv = [
      self.z[1]*cos(self.x[3]+self.z[2]),
      self.z[1]*sin(self.x[3]+self.z[2]),
      -pose_list[string(head_t)][3]+z[2]-head_z[2]-z[3]+head_z[3]
    ]
    self.m = self.x + delta_obsrv
    
    # normalize -pi ~ pi
    while self.m[3] >= pi
      self.m[3] -= pi*2
    end
    while self.m[3] < -pi
      self.m[3] += pi*2
    end

    return self
  end
end