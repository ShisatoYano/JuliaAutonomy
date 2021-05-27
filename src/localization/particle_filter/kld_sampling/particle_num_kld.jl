# calculate required particle num for kld sampling

module ParticleNumKld
  using Plots, Distributions
  pyplot()

  function num(epsilon, delta, bin_num)
    return ceil(quantile(Chisq(bin_num-1), 1-delta)/(2*epsilon))
  end

  function main(is_test=false)
    bs = 2:1:9
    n = [num(0.1, 0.01, b) for b in bs]
    p1 = plot(bs, n, title="bin: 2-10")

    bs = 2:1:9999
    n = [num(0.1, 0.01, b) for b in bs]
    p2 = plot(bs, n, title="bin: 2-100000")

    plot(p1, p2, layout=(1, 2), size=(750, 300), legend=false)

    if is_test == false
      save_path = joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/kld_sampling/particle_num_kld.png")
      savefig(save_path)
    end
  end
end