# class for agent
# deciding control order to robot

mutable struct Agent
    speed
    yaw_rate

    # init
    function Agent(speed::Float64, yaw_rate::Float64)
        self = new()
        self.speed = speed
        self.yaw_rate = yaw_rate
        return self
    end
end

function decision(self::Agent)
    return self.speed, self.yaw_rate
end