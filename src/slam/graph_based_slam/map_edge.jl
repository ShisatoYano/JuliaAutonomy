# module for landmark estimation by graph based slam

using LinearAlgebra

mutable struct MapEdge
  x
  z
  m
  omega
  xi

  # init
  # head_t: time when target landmark was observed for the first time
  # head_z: observed values when target landmark was observed for the first time
  function MapEdge(t, z, head_t, head_z, pose_list;
                   sensor_noise_rate=[0.14, 0.05])
    self = new()
    self.x = pose_list[string(t)]
    self.z = z

    # landmark's pose
    delta_obsrv = [
      self.z[1]*cos(self.x[3]+self.z[2]),
      self.z[1]*sin(self.x[3]+self.z[2])
    ]
    self.m = self.x[1:2] + delta_obsrv

    # precision matrix
    Q1 = diagm(0 => [(self.z[1]*sensor_noise_rate[1])^2,
                     sensor_noise_rate[2]^2])
    s1 = sin(self.x[3] + self.z[2])
    c1 = cos(self.x[3] + self.z[2])
    R = [-c1  self.z[1]*s1;
         -s1 -self.z[1]*c1]
    self.omega = R * Q1 * R'

    # coefficient vector
    self.xi = self.omega * self.m

    return self
  end
end