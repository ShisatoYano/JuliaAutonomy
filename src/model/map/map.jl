# module for drawing map
# can put an object

using Plots
pyplot()

include(joinpath(split(@__FILE__, "src")[1], "src/model/object/object.jl"))
include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))

mutable struct Map
    objects

    # init
    function Map()
        self = new()
        self.objects = []
        return self
    end
end

function add_object(self::Map, object)
    push!(self.objects, object)
end

function draw!(self::Map)
    for obj in self.objects
        draw!(obj)
    end
end