# class for representing particle

include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/robot.jl"))

mutable struct Particle
  pose

  # init
  function Particle(init_pose::Array)
    self = new()
    self.pose = init_pose
    return self
  end
end

function motion_update(self::Particle, speed, yaw_rate, 
                       time_interval, noise_rate_pdf)
  ns = rand(noise_rate_pdf) # [nn, no, on, oo]
  noised_spd = speed + ns[1]*sqrt(abs(speed)/time_interval) + ns[2]*sqrt(abs(yaw_rate)/time_interval)
  noised_yr = yaw_rate + ns[3]*sqrt(abs(speed)/time_interval) + ns[4]*sqrt(abs(yaw_rate)/time_interval)
  self.pose = state_transition(noised_spd, noised_yr, time_interval, self.pose)
end