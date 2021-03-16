# define world coordinate system

module World
    using Plots
    pyplot()

    # objects array
    objects = []

    # register object
    function append(obj)
        push!(objects, obj)
    end

    # draw registered objects
    function draw()
        
    end
end