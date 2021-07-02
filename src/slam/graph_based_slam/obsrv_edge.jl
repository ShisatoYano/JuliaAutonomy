# module for representing observation edge

using LinearAlgebra

mutable struct ObsrvEdge
  t1
  t2
  z1
  z2
  x1
  x2
  Omega

  # init
  function ObsrvEdge(t1, t2, z1, z2, pose_list; 
                     sensor_noise_rate=[0.14,0.05,0.05])
    @assert z1[1] == z2[1] # prevent id is different

    self = new()

    self.t1 = t1 # time
    self.t2 = t2
    self.z1 = z1[2] # observation [distance, direction orientation]
    self.z2 = z2[2]
    self.x1 = pose_list[string(t1)] # pose [x, y, theta]
    self.x2 = pose_list[string(t2)]

    sin1 = sin(self.x1[3] + self.z1[2])
    cos1 = cos(self.x1[3] + self.z1[2])
    sin2 = sin(self.x2[3] + self.z2[2])
    cos2 = cos(self.x2[3] + self.z2[2])

    # calculate error
    error_pose = self.x2 - self.x1
    error_obsrv = [
      self.z2[1]*cos2-self.z1[1]*cos1,
      self.z2[1]*sin2-self.z1[1]*sin1,
      self.z2[2]-self.z2[3]-self.z1[2]+self.z1[3]
    ]
    error = error_pose + error_obsrv

    # normalize -pi ~ pi
    while error[3] >= pi
      error[3] -= pi*2
    end
    while error[3] < -pi
      error[3] += pi*2
    end

    # precision matrix
    Q1 = diagm(0 => [(self.z1[1]*sensor_noise_rate[1])^2,
                     sensor_noise_rate[2]^2,
                     sensor_noise_rate[3]^2])
    R1 = -[cos1 -self.z1[1]*sin1 0;
           sin1  self.z1[1]*cos1 0;
              0                1 -1]
    Q2 = diagm(0 => [(self.z2[1]*sensor_noise_rate[1])^2,
                     sensor_noise_rate[2]^2,
                     sensor_noise_rate[3]^2])
    R2 = [cos2 -self.z2[1]*sin2 0;
          sin2  self.z2[1]*cos2 0;
             0                1 -1]
    Sigma = R1*Q1*R1' + R2*Q2*R2'
    self.Omega = inv(Sigma)

    return self
  end
end