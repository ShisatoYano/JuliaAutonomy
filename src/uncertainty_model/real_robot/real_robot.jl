# class for drawing robot
# differential two wheeled robot model
# considering uncertainty like noise/bias/stuck/kidnap

using Plots, Random, Distributions
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/robot_model/movement/agent.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/uncertainty_model/real_camera/real_camera.jl"))

mutable struct RealRobot
    pose
    radius
    color
    agent
    delta_time
    noise_expon
    noise_norm
    dist_until_noise
    bias_rate_spd
    bias_rate_yr
    stuck_exporn
    escape_exporn
    time_until_stuck
    time_until_escape
    kidnap_exporn
    kidnap_x_uniform
    kidnap_y_uniform
    kidnap_theta_uniform
    time_until_kidnap
    camera
    is_stuck
    traj_x
    traj_y

    # init
    function RealRobot(pose::Array, radius::Float64, color::String,
                       agent::Agent, delta_time::Float64;
                       camera=nothing,
                       noise_per_meter::Int64=0, 
                       noise_std::Float64=0.0,
                       bias_rate_stds::Array=[0.0, 0.0],
                       exp_stuck_time::Float64=1e100, 
                       exp_escape_time::Float64=1e-100,
                       exp_kidnap_time::Float64=1e100, 
                       kidnap_rx::Array=[-5.0, 5.0], 
                       kidnap_ry::Array=[-5.0, 5.0])
        self = new()
        self.pose = pose
        self.radius = radius
        self.color = color
        self.agent = agent
        self.delta_time = delta_time
        self.noise_expon = Exponential(1.0/(1e-100 + noise_per_meter))
        self.noise_norm = Normal(0.0, noise_std)
        self.dist_until_noise = rand(self.noise_expon)
        self.bias_rate_spd = rand(Normal(1.0, bias_rate_stds[1]))
        self.bias_rate_yr = rand(Normal(1.0, bias_rate_stds[2]))
        self.stuck_exporn = Exponential(exp_stuck_time)
        self.escape_exporn = Exponential(exp_escape_time)
        self.time_until_stuck = rand(self.stuck_exporn)
        self.time_until_escape = rand(self.escape_exporn)
        self.kidnap_exporn = Exponential(exp_kidnap_time)
        self.kidnap_x_uniform = Uniform(kidnap_rx[1], kidnap_rx[2])
        self.kidnap_y_uniform = Uniform(kidnap_ry[1], kidnap_ry[2])
        self.kidnap_theta_uniform = Uniform(0.0, 2 * pi)
        self.time_until_kidnap = rand(self.kidnap_exporn)
        self.camera = camera
        self.is_stuck = false
        self.traj_x = [pose[1]]
        self.traj_y = [pose[2]]
        return self
    end
end

function noise(self::RealRobot, pose::Array, speed::Float64,
               yaw_rate::Float64, delta_time::Float64)
    self.dist_until_noise -= abs(speed) * delta_time + self.radius * abs(yaw_rate) * delta_time
    if self.dist_until_noise <= 0.0
        self.dist_until_noise += rand(self.noise_expon)
        pose[3] += rand(self.noise_norm)
    end
    return pose
end

function bias(self::RealRobot, speed::Float64, yaw_rate::Float64)
    return speed * self.bias_rate_spd, yaw_rate * self.bias_rate_yr
end

function stuck(self::RealRobot, speed::Float64, 
               yaw_rate::Float64, delta_time::Float64)
    if self.is_stuck
        self.time_until_escape -= delta_time
        if self.time_until_escape <= 0.0
            self.time_until_escape += rand(self.escape_exporn)
            self.is_stuck = false
        end
    else
        self.time_until_stuck -= delta_time
        if self.time_until_stuck <= 0.0
            self.time_until_stuck += rand(self.stuck_exporn)
            self.is_stuck = true
        end
    end
    return speed * (!self.is_stuck), yaw_rate * (!self.is_stuck)
end

function kidnap(self::RealRobot, pose::Array, delta_time::Float64)
    self.time_until_kidnap -= delta_time
    if self.time_until_kidnap <= 0.0
        self.time_until_kidnap += rand(self.kidnap_exporn)
        return [rand(self.kidnap_x_uniform), rand(self.kidnap_y_uniform), rand(self.kidnap_theta_uniform)]
    else
        return pose
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
    
    # draw observation
    observation = []
    if self.camera != nothing
        data(self.camera, self.pose)
        draw!(self.camera, self.pose)
        observation = self.camera.last_data    
    end

    # draw particles
    draw!(self.agent, observation)
    
    # next pose
    spd, yr = decision(self.agent)
    spd, yr = bias(self, spd, yr)
    spd, yr = stuck(self, spd, yr, self.delta_time)
    self.pose = state_transition(spd, yr, self.delta_time, self.pose)
    self.pose = noise(self, self.pose, spd, yr, self.delta_time)
    self.pose = kidnap(self, self.pose, self.delta_time)
    push!(self.traj_x, self.pose[1]), push!(self.traj_y, self.pose[2])
end