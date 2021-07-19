module DrawValueHeatmap
  using Plots
  pyplot()

  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/policy_evaluator.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))

  function main(is_test=false)
    puddles = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1), Puddle([-0.5, -2.0], [2.5, 1.0], 0.1)]

    pe = PolicyEvaluator([0.2, 0.2, pi/18], Goal(-3, -3), puddles, 0.1, 10)

    counter = 0
    delta = 1e100

    while delta > 0.01
      delta = policy_evaluation_sweep(pe)
      counter += 1
      println("$(counter), $(delta)")
    end

    v = pe.value_function[:, :, 18]
    heatmap(v', aspect_ratio=true)

    if is_test == false
      save_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/markov_decision_process/delta_i18_heatmap.png")
      savefig(save_path)
    end
  end
end