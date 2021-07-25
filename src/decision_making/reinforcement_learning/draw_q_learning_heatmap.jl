module DrawQlearningHeatmap
  using Plots
  pyplot()

  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/policy_evaluator.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/dynamic_programming.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))

  function main(is_test=false)
    puddles = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1), Puddle([-0.5, -2.0], [2.5, 1.0], 0.1)]

    pe = PolicyEvaluator([0.2, 0.2, pi/18], Goal(-3, -3), puddles, 0.1, 10)

    if is_test == false
      txt_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/reinforcement_learning/policy.txt")
      fp = open(txt_path, "w")
      for i in pe.indexes
        p = pe.policy[i[1]+1, i[2]+1, i[3]+1, :]
        write(fp, "$(i[1]) $(i[2]) $(i[3]) $(p[1]) $(p[2])\n")
      end
      close(fp)

      txt_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/reinforcement_learning/value.txt")
      fp = open(txt_path, "w")
      for i in pe.indexes
        v = pe.value_function[i[1]+1, i[2]+1, i[3]+1]
        write(fp, "$(i[1]) $(i[2]) $(i[3]) $(v)\n")
      end
      close(fp)
    end
  end
end