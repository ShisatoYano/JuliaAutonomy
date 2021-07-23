module DrawValueHeatmap
  using Plots
  pyplot()

  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/policy_evaluator.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/dynamic_programming.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))

  function main(is_test=false)
    puddles = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1), Puddle([-0.5, -2.0], [2.5, 1.0], 0.1)]

    dp = DynamicProgramming([0.2, 0.2, pi/18], Goal(-3, -3), puddles, 0.1, 10)

    counter = 0
    delta = 1e100

    if is_test == false
      while delta > 0.01
        delta = policy_iteration_sweep(dp)
        counter += 1
        println("$(counter), $(delta)")
      end

      txt_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/policy.txt")
      fp = open(txt_path, "w")
      for i in dp.indexes
        p = dp.policy[i[1]+1, i[2]+1, i[3]+1, :]
        write(fp, "$(i[1]) $(i[2]) $(i[3]) $(p[1]) $(p[2])\n")
      end
      close(fp)

      txt_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/value.txt")
      fp = open(txt_path, "w")
      for i in dp.indexes
        v = dp.value_function[i[1]+1, i[2]+1, i[3]+1]
        write(fp, "$(i[1]) $(i[2]) $(i[3]) $(v)\n")
      end
      close(fp)
    else
      for i in 1:10
        delta = policy_iteration_sweep(dp)
        counter += 1
      end
    end

    # v = dp.value_function[:, :, 18]
    # heatmap(v', aspect_ratio=true)
    # if is_test == false
    #   save_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/dp_i18_sweep_heatmap.png")
    #   savefig(save_path)
    # end

    # p = zeros(Tuple(dp.index_nums))
    # for i in dp.indexes
    #   p[i[1]+1, i[2]+1, i[3]+1] = sum(dp.policy[i[1]+1, i[2]+1, i[3]+1, :])
    # end
    # heatmap(p[:, :, 18]', aspect_ratio=true)
    # if is_test == false
    #   save_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/policy_i18_sweep_heatmap.png")
    #   savefig(save_path)
    # end
  end
end