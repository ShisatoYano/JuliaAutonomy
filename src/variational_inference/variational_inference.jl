# variational inference sample code

module VariationalInference
  using DataFrames, CSV, StatsBase, Plots, Distributions
  pyplot()
  
  function main(;test=false)
    # read original data
    data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_600.txt")
    all_data = CSV.read(data_path, DataFrame, 
                        header=["date", "time", "ir", "z"],
                        delim=' ')
    data = sort(sample(all_data.z, 1000))
    data = DataFrame(z=data)
    
    # initialize responsibility
    K = 2 # num of class
    n = Int(ceil(size(data)[1]/K))
    for k in 1:K
      data_k = []
      for i in 1:size(data)[1]
        if k == Int(ceil(i/n))
          append!(data_k, 1.0)
        else
          append!(data_k, 0.0)
        end
      end
      if k == 1
        data = hcat(data, DataFrame(one=data_k))
      else  
        data = hcat(data, DataFrame(two=data_k))
      end
    end

    params = DataFrame()
    for k in 1:K
      if k == 1
        params = update_parameters(data, k)
      else
        params = vcat(params, update_parameters(data, k))
      end
    end
    draw_sensor_dist(data, params, K,
                     "src/variational_inference/draw_sensor_dist_sample.png",
                     test)
    
  end

  function update_parameters(ds, k, mu_avg=600, zeta=1, alpha=1, beta=1, tau=1)
    if k == 1
      key_class = "one"
    else
      key_class = "two" 
    end

    # calculate R, S, T
    R = sum([ds[i, key_class] for i in 1:size(ds)[1]])
    S = sum([ds[i, key_class]*ds[i, :z] for i in 1:size(ds)[1]])
    T = sum([ds[i, key_class]*(ds[i, :z]^2) for i in 1:size(ds)[1]])
    
    # store calculated parameters temporarily
    hat = Dict()
    hat["tau"] = R + tau
    hat["zeta"] = R + zeta
    hat["mu_avg"] = (S + zeta*mu_avg)/hat["zeta"]
    hat["alpha"] = R/2 + alpha
    hat["beta"] = (T + zeta*(mu_avg^2) - hat["zeta"]*(hat["mu_avg"]^2))/2 + beta
    hat["z_std"] = sqrt(hat["beta"]/hat["alpha"])

    return DataFrame(hat)
  end

  function draw_sensor_dist(data, params, K, save_name, test)
    pi_ = rand(Dirichlet([params[k, "tau"] for k in 1:K]))
    pdfs = [Normal(params[k, "mu_avg"], params[k, "z_std"]) for k in 1:K]
    
    xs = range(600, 650, length=Int64(floor(50/0.5)))
    
    # histogram of observation
    histogram(data.z, bins=(maximum(data.z)-minimum(data.z)), color=:gray, label="histogram")
    # draw gaussian mixture distribution
    ys = [sum([pdf(pdfs[k], x)*pi_[k] for k in 1:K])*size(data)[1] for x in xs]
    plot!(xs, ys, color=:red, label="Mixture")
    # gaussian distribution of each cluster
    for k in 1:K
      ys = [pdf(pdfs[k], x)*pi_[k]*size(data)[1] for x in xs]
      plot!(xs, ys, color=:blue, label="Cluster$(k)")
    end
    if test == false
      save_path = joinpath(split(@__FILE__, "src")[1], save_name)
      savefig(save_path)
    end
  end

end