# class for agent
# deciding control order to robot

include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/monte_carlo_localization.jl"))

mutable struct Agent
    speed
    yaw_rate
    time_interval
    estimator
    prev_spd
    prev_yr

    # init
    function Agent(speed::Float64, yaw_rate::Float64;
                   time_interval::Float64=0.1,
                   estimator=nothing)
        self = new()
        self.speed = speed
        self.yaw_rate = yaw_rate
        self.time_interval = time_interval
        self.estimator = estimator
        self.prev_spd = 0.0
        self.prev_yr = 0.0
        return self
    end
end

function decision(self::Agent)
    return self.speed, self.yaw_rate
end

function draw!(self::Agent)
    if self.estimator != nothing
        motion_update(self.estimator, self.prev_spd, self.prev_yr, self.time_interval)
        draw!(self.estimator)
        self.prev_spd, self.prev_yr = self.speed, self.yaw_rate
    end
end