# class for drawing robot
# differential two wheeled robot model

using Plots
pyplot()

mutable struct Robot
    pose
    radius
    color

    # init
    function Robot(pose::Array, radius::Float64, color::String)
        self = new()
        self.pose = pose
        self.radius = radius
        self.color = color
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

function draw!(self::Robot)
    x, y, theta = self.pose[1], self.pose[2], self.pose[3]
    xn = x + self.radius * cos(theta)
    yn = y + self.radius * sin(theta)
    plot!([x, xn], [y, yn], color=self.color, 
         legend=false, aspect_ratio=true)
    plot!(circle(x, y, self.radius), linecolor=self.color, 
          aspect_ratio=true)
end