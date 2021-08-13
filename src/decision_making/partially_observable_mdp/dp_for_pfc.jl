module DpForPfc
  using Plots
  pyplot()

  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/dynamic_programming.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))

  function main(is_test=false)
    puddles = []

    dp = DynamicProgramming([0.2, 0.2, pi/18], Goal(-1.5, -1.5), puddles, 0.1, 10)

    counter = 0
    delta = 1e100

    if is_test == false
      while delta > 0.01
        delta = value_iteration_sweep(dp)
        counter += 1
        println("$(counter), $(delta)")
      end

      txt_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/partially_observable_mdp/policy.txt")
      fp = open(txt_path, "w")
      for i in dp.indexes
        p = dp.policy[i[1]+1, i[2]+1, i[3]+1, :]
        write(fp, "$(i[1]) $(i[2]) $(i[3]) $(p[1]) $(p[2])\n")
      end
      close(fp)

      txt_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/partially_observable_mdp/value.txt")
      fp = open(txt_path, "w")
      for i in dp.indexes
        v = dp.value_function[i[1]+1, i[2]+1, i[3]+1]
        write(fp, "$(i[1]) $(i[2]) $(i[3]) $(v)\n")
      end
      close(fp)
    else
      for i in 1:10
        delta = value_iteration_sweep(dp)
        counter += 1
      end
    end
  end
end