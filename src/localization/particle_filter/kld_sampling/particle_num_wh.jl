# calculate required particle num for kld sampling
# by wilson-hilferty transformation

module ParticleNumWh
  using Distributions

  function num(epsilon, delta, bin_num)
    return ceil(quantile(Chisq(bin_num-1), 1-delta)/(2*epsilon))
  end

  function num_wh(epsilon, delta, bin_num)
    dof = bin_num - 1
    z = quantile(Normal(), 1 - delta)
    return ceil(dof/(2*epsilon)*(1-2/(9*dof)+sqrt(2/(9*dof))*z)^3)
  end

  function main()
    bins = [2, 4, 8, 1000, 10000, 100000]
    for bin in bins
      println("bin:$(bin), ϵ=0.1, δ=0.01, chisq=$(num(0.1, 0.01, bin)), norm=$(num_wh(0.1, 0.01, bin))")
      println("bin:$(bin), ϵ=0.5, δ=0.01, chisq=$(num(0.5, 0.01, bin)), norm=$(num_wh(0.5, 0.01, bin))")
      println("bin:$(bin), ϵ=0.5, δ=0.05, chisq=$(num(0.5, 0.05, bin)), norm=$(num_wh(0.5, 0.05, bin))")
    end
  end
end