# class for drawing robot
# differential two wheeled robot model
# considering uncertainty because of noise/bias

using Plots, Random, Distributions
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/agent.jl"))

mutable struct RealRobot
    pose
    radius
    color
    agent
    delta_time
    expon
    norm
    dist_until_noise
    bias_rate_spd
    bias_rate_yr
    traj_x
    traj_y

    # init
    function RealRobot(pose::Array, radius::Float64, color::String,
                       agent::Agent, delta_time::Float64,
                       noise_per_meter::Int64, noise_std::Float64,
                       bias_rate_stds::Array)
        self = new()
        self.pose = pose
        self.radius = radius
        self.color = color
        self.agent = agent
        self.delta_time = delta_time
        self.expon = Exponential(1e-100 + noise_per_meter)
        self.norm = Normal(0.0, noise_std)
        self.dist_until_noise = rand(self.expon)
        self.bias_rate_spd = rand(Normal(1.0, bias_rate_stds[1]))
        self.bias_rate_yr = rand(Normal(1.0, bias_rate_stds[2]))
        self.traj_x = [pose[1]]
        self.traj_y = [pose[2]]
        return self
    end
end

function noise(self::RealRobot, pose::Array, speed::Float64,
               yaw_rate::Float64, delta_time::Float64)
    self.dist_until_noise -= abs(speed) * delta_time + self.radius * abs(yaw_rate) * delta_time
    if self.dist_until_noise <= 0.0
        self.dist_until_noise += rand(self.expon)
        pose[3] += rand(self.norm)
    end
    return pose
end

function bias(self::RealRobot, speed::Float64, yaw_rate::Float64)
    return speed * self.bias_rate_spd, yaw_rate * self.bias_rate_yr
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
    spd, yr = bias(self, spd, yr)
    self.pose = state_transition(spd, yr, self.delta_time, self.pose)
    self.pose = noise(self, self.pose, spd, yr, self.delta_time)
    push!(self.traj_x, self.pose[1]), push!(self.traj_y, self.pose[2])
end