# module for playing monte carlo localization by particle filter
# particles are resampled by random sampling

module AnimeMclRandSamp
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/object/object.jl"))

  function main(time_interval=0.1)
    w = World(-5.0, 5.0, -5.0, 5.0)
    
    m = Map()
    add_object(m, Object(-4.0, 2.0))

    anime = @animate for t in 0:time_interval:30
      draw(w)

      annotate!(-3.5, 4.5, "t = $(t)", "black")

      draw!(m)
    end

    path = "src/localization/particle_filter/random_sampling/anime_mcl_rand_samp.gif"
    gif(anime, fps=15, joinpath(split(@__FILE__, "src")[1], path))
  end
end