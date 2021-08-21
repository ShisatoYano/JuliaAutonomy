# bayesian inference for gauss-gamma distribution

module GaussGamma
  using DataFrames, CSV, Plots, FreqTables, NamedArrays, Distributions
  using StatsBase, Statistics
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
    
    # step2: calculate posterior distribution
    # update with not many observation
    data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
    df_200_mm = CSV.read(data_path, DataFrame, 
                         header=["date", "time", "ir", "lidar"],
                         delim=' ')
    lidar = df_200_mm.lidar
    samples = sample(lidar, 5)
    println("Samples: $(samples)")
    println("Mean: $(sum(samples)/length(samples))")
    println("Std dev: $(Statistics.std(samples, corrected=false))")
    # calculate parameters
    N = length(samples)
    mu_N = 1.0/(N+zeta_0)*sum(samples) + zeta_0/(N+zeta_0)*mu_0
    zeta_N = N + zeta_0
    alpha_N = N/2 + alpha_0
    beta_N = 0.5*(sum([z^2 for z in samples]) + zeta_0*(mu_0^2) - zeta_N*(mu_N^2)) + beta_0
    println("$(mu_N) $(zeta_N) $(alpha_N) $(beta_N)")
    # posterior gamma distribution of lambda
    lambda_dist = gen_lambda_dist(alpha_N, beta_N)
    draw_dist_pdf(lambda_dist, 0, 5, 0.01,
                  "src/bayesian_inference/posterior_lambda_dist_N5.png",
                  test)
    draw_dist_pdf(lambda_dist, 0, 0.25, 0.00001,
                  "src/bayesian_inference/posterior_lambda_dist_N5_narrow.png",
                  test)
    # posterior normal distribution of mu
    lambda = rand(lambda_dist)
    mu_dist = gen_mu_dist(mu_N, zeta_N, lambda)
    draw_dist_pdf(mu_dist, 180, 220, 0.1,
                  "src/bayesian_inference/posterior_mu_dist_N5.png",
                  test)
    println("Mean(N=5): $(mu_dist.μ)")
    println("Std dev(N=5): $(sqrt(1/lambda))")

  end

  function gen_lambda_dist(alpha, beta)
    return Gamma(alpha, 1/beta)
  end

  function gen_mu_dist(mu_mean, zeta, lambda)
    return Normal(mu_mean, sqrt(1/(zeta*lambda)))
  end

  function draw_dist_pdf(dist, range_min, range_max, step, save_name, test)
    xs = range(range_min, range_max, length=Int64(floor((range_max-range_min)/step)))
    println(xs)
    ys = [pdf(dist, x) for x in xs]
    plot(xs, ys, label="PDF")

    if test == false
      save_path = joinpath(split(@__FILE__, "src")[1], save_name)
      savefig(save_path)
    end
  end
end