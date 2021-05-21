function state_transition(speed, yaw_rate, time, pose)
  theta = pose[3]

  # yaw rate is almost zero or not
  if abs(yaw_rate) < 1e-10
      return pose + [speed*cos(theta)*time,
                     speed*sin(theta)*time,
                     yaw_rate*time]
  else
      return pose + [speed/yaw_rate*(sin(theta+yaw_rate*time)-sin(theta)),
                     speed/yaw_rate*(-cos(theta+yaw_rate*time)+cos(theta)),
                     yaw_rate*time]
  end
end