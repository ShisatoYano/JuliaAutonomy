# class for drawing robot
# differential two wheeled robot model
# considering uncertainty because of noise/bias

using Plots
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/agent.jl"))

mutable struct RealRobot
    pose
    radius
    color
    agent
    delta_time
    traj_x
    traj_y

    # init
    function RealRobot(pose::Array, radius::Float64, color::String,
                       agent::Agent, delta_time::Float64)
        self = new()
        self.pose = pose
        self.radius = radius
        self.color = color
        self.agent = agent
        self.delta_time = delta_time
        self.traj_x = [pose[1]]
        self.traj_y = [pose[2]]
        return self
    end
end

function circle(x, y, r)
    theta = LinRange(0, 2*pi, 500)
    x .+ r * sin.(theta), y .+ r * cos.(theta)
end

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

function draw!(self::RealRobot)
    # current pose
    x, y, theta = self.pose[1], self.pose[2], self.pose[3]
    xn = x + self.radius * cos(theta)
    yn = y + self.radius * sin(theta)
    
    # draw robot and current pose
    plot!([x, xn], [y, yn], color=self.color, 
         legend=false, aspect_ratio=true)
    plot!(circle(x, y, self.radius), linecolor=self.color, 
          aspect_ratio=true)
    # draw trajectory
    plot!(self.traj_x, self.traj_y, color=self.color, 
          legend=false, aspect_ratio=true)
    
    # next pose
    spd, yr = decision(self.agent)
    next_pose = state_transition(spd, yr, self.delta_time, self.pose)
    self.pose = next_pose
    push!(self.traj_x, self.pose[1]), push!(self.traj_y, self.pose[2])
end