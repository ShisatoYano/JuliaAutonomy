# bayesian inference for gauss-gamma distribution

module GaussGamma
  using DataFrames, CSV, Plots, FreqTables, NamedArrays, Distributions
  pyplot()

  function main(;test=false)
    # step1: generate prior distribution
    # initial parameters
    mu_0 = 200
    zeta_0 = 1
    alpha_0 = 1
    beta_0 = 2
    # prior gamma distribution of lambda
    lambda_dist = gen_lambda_dist(alpha_0, beta_0)
    draw_dist_pdf(lambda_dist, 0, 5, 0.01,
                  "src/bayesian_inference/prior_lambda_dist.png",
                  test)
    # prior normal distribution of mu
    lambda = rand(lambda_dist)
    mu_dist = gen_mu_dist(mu_0, zeta_0, lambda)
    draw_dist_pdf(mu_dist, 180, 220, 0.1,
                  "src/bayesian_inference/prior_mu_dist.png",
                  test)

  end

  function gen_lambda_dist(alpha, beta)
    return Gamma(alpha, 1/beta)
  end

  function gen_mu_dist(mu_mean, zeta, lambda)
    return Normal(mu_mean, sqrt(1/(zeta*lambda)))
  end

  function draw_dist_pdf(dist, range_min, range_max, step, save_name, test)
    xs = range(range_min, range_max, length=Int64((range_max-range_min)/step))
    ys = [pdf(dist, x) for x in xs]
    plot(xs, ys, label="PDF")

    if test == false
      save_path = joinpath(split(@__FILE__, "src")[1], save_name)
      savefig(save_path)
    end
  end
end