module ValueHeatmapAmdp
  using Plots
  pyplot()

  include(joinpath(split(@__FILE__, "src")[1], "src/decision_making/partially_observable_mdp/belief_dynamic_programming.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/goal/goal.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/puddle/puddle.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/map/map.jl"))

  function main(is_test=false)
    puddles = [Puddle([-2.0, 0.0], [0.0, 2.0], 0.1), Puddle([-0.5, -2.0], [2.5, 1.0], 0.1)]

    map = Map()
    for (id, lm) in enumerate([[1.0, 4.0], [4.0, 1.0], [-4.0, 1.0], [-2.0, 1.0]])
      add_object(map, Object(lm[1], lm[2], id=id))
    end

    sensor = Sensor(map, dist_noise_rate=0.1, dir_noise=pi/90)

    dp = BeliefDynamicProgramming([0.2, 0.2, pi/18], Goal(-3, 0), puddles, 0.1, 10, sensor)

    counter = 0
    delta = 1e100

    if is_test == false
      while delta > 0.01
        delta = value_iteration_sweep(dp)
        counter += 1
        println("$(counter), $(delta)")
      end

      txt_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/partially_observable_mdp/policy_amdp.txt")
      fp = open(txt_path, "w")
      for i in dp.indexes
        p = dp.policy[i[1]+1, i[2]+1, i[3]+1, :]
        write(fp, "$(i[1]) $(i[2]) $(i[3]) $(i[4]) $(p[1]) $(p[2])\n")
      end
      close(fp)

      txt_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/partially_observable_mdp/value_amdp.txt")
      fp = open(txt_path, "w")
      for i in dp.indexes
        v = dp.value_function[i[1]+1, i[2]+1, i[3]+1, i[4]+1]
        write(fp, "$(i[1]) $(i[2]) $(i[3]) $(i[4]) $(v)\n")
      end
      close(fp)
    else
      for i in 1:10
        delta = value_iteration_sweep(dp)
        counter += 1
      end
    end

    v = dp.value_function[:, :, 18, 1]
    heatmap(v', aspect_ratio=true)
    if is_test == false
      save_path = joinpath(split(@__FILE__, "src")[1], "src/decision_making/partially_observable_mdp/value_heatmap_amdp.png")
      savefig(save_path)
    end
  end
end