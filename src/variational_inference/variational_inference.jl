# variational inference sample code

module VariationalInference
  using DataFrames, CSV, StatsBase
  
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
      # data = hcat(data, DataFrame(=data_k))
    end
    println(data)

    
    
  end

end