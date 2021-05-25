# calculate required particle num for kld sampling

module DecideParticleNum
  using Plots
  pyplot()

  function main(is_test=false)
    

    if is_test == false
      save_path = joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/kld_sampling/particle_num.png")
      savefig(save_path)
    end
  end
end