# dirichlet distribution sample

module DirichletDistribution
  using Distributions

  function main()
    tau = [1, 2, 3, 4, 5]

    for i in 1:3
      pi_ = rand(Dirichlet(tau))
      println("π = $(pi_), Sum: $(sum(pi_))")
    end
  end
end