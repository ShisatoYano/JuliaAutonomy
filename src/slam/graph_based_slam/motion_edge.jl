# module for representing motion edge

using LinearAlgebra

include(joinpath(split(@__FILE__, "src")[1], "src/common/state_transition/state_transition.jl"))

mutable struct MotionEdge
  t1
  t2
  x1
  x2
  omega_upper_right
  omega_upper_left
  omega_lower_right
  omega_lower_left
  xi_upper
  xi_lower

  # matrix of input noise
  function mat_M(speed, yaw_rate, time, stds)
    return diagm(0 => [stds["nn"]^2*abs(speed)/time + stds["no"]^2*abs(yaw_rate)/time,
                       stds["on"]^2*abs(speed)/time + stds["oo"]^2*abs(yaw_rate)/time])
  end
  
  # jacobian of input
  function mat_A(speed, yaw_rate, time, theta)
    st, ct = sin(theta), cos(theta)
    stw, ctw = sin(theta + yaw_rate * time), cos(theta + yaw_rate * time)
    return [(stw - st)/yaw_rate  -speed/(yaw_rate^2)*(stw - st) + speed/yaw_rate*time*ctw;
            (-ctw + ct)/yaw_rate -speed/(yaw_rate^2)*(-ctw + ct) + speed/yaw_rate*time*stw;
            0                    time]
  end

  # jacobian of pose
  function mat_F(speed, yaw_rate, time, theta)
    F = diagm(0 => [1.0, 1.0, 1.0])
    F[1, 3] = speed / yaw_rate * (cos(theta + yaw_rate * time) - cos(theta))
    F[2, 3] = speed / yaw_rate * (sin(theta + yaw_rate * time) - sin(theta))
    return F
  end

  # init
  function MotionEdge(t1, t2, pose_list, input_list, delta; 
                      motion_noise_stds=Dict("nn"=>0.20, "no"=>0.001, "on"=>0.11, "oo"=>0.20))
    self = new()

    self.t1 = t1 # time
    self.t2 = t2
    self.x1 = pose_list[string(t1)] # pose [x, y, theta]
    self.x2 = pose_list[string(t2)]
    speed = input_list[string(t2)][1] # input [speed, yaw_rate]
    yaw_rate = input_list[string(t2)][2]
    if abs(yaw_rate) < 1e-5
      yaw_rate = 1e-5
    end

    # noise matrix and jacobian
    M = mat_M(speed, yaw_rate, delta, motion_noise_stds)
    A = mat_A(speed, yaw_rate, delta, self.x1[3])
    F = mat_F(speed, yaw_rate, delta, self.x1[3])

    # precision matrix of edge
    omega_edge = inv(A*M*A' + Matrix{Float64}(I,3,3).*0.0001)

    # precision matrix of graph
    self.omega_upper_left = F' * omega_edge * F
    self.omega_upper_right = -F' * omega_edge
    self.omega_lower_left = -omega_edge * F
    self.omega_lower_right = omega_edge

    # coefficient vector
    x2 = state_transition(speed, yaw_rate, delta, self.x1)
    self.xi_upper = F' * omega_edge * (self.x2 - x2)
    self.xi_lower = -omega_edge * (self.x2 - x2)

    return self
  end
end