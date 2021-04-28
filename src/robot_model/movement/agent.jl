# class for agent
# deciding control order to robot

include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/monte_carlo_localization.jl"))

mutable struct Agent
    speed
    yaw_rate
    estimator

    # init
    function Agent(speed::Float64, yaw_rate::Float64;
                   estimator=nothing)
        self = new()
        self.speed = speed
        self.yaw_rate = yaw_rate
        self.estimator = estimator
        return self
    end
end

function decision(self::Agent)
    return self.speed, self.yaw_rate
end

function draw!(self::Agent)
    draw!(self.estimator)
end