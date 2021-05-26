# calculate required particle num for kld sampling

module ParticleNumKld
  using Plots, Distributions
  pyplot()

  function num(epsilon, delta, bin_num)
    
  end

  function main(is_test=false)
    bs = 2:1:10


    if is_test == false
      save_path = joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/kld_sampling/particle_num_kld.png")
      savefig(save_path)
    end
  end
end