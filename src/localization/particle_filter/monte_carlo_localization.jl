include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/particle.jl"))

mutable struct MonteCarloLocalization
  particles

  # init
  function MonteCarloLocalization(init_pose::Array, num::Int64)
    self = new()
    self.particles = []
    for i in 1:num
      push!(self.particles, Particle(init_pose))
    end
  end
end