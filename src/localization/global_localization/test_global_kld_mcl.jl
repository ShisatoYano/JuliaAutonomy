# test global localization by mcl, particle filter
# kld sampling
# calculate accuracy by 1000 times test

module TestGlobalKldMcl
  using Distributions

  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/world.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/model/robot/differential_wheeled_robot/differential_wheeled_robot.jl"))
  include(joinpath(split(@__FILE__, "src")[1], "src/localization/global_localization/global_kld_mcl.jl"))

  function single_test(time_interval=0.1, test_time=30; max_num=10000)
    w = World(-5.0, 5.0, -5.0, 5.0)
    
    m = Map()
    add_object(m, Object(-4.0, 2.0, id=1))
    add_object(m, Object(2.0, -3.0, id=2))
    add_object(m, Object(3.0, 3.0, id=3))

    s = Sensor(m, dist_noise_rate=0.1, dir_noise=pi/90,
               dist_bias_rate_stddev=0.1, dir_bias_stddev=pi/90)
    
    init_pose = [rand(Uniform(-5.0, 5.0)), rand(Uniform(-5.0, 5.0)), rand(Uniform(-pi, pi))]
    e = GlobalKldMcl(max_num, env_map=m)
    circling = Agent(0.2, 10.0/180*pi, estimator=e)
    r = DifferentialWheeledRobot(init_pose, 0.2, "black",
                                 circling, time_interval,
                                 noise_per_meter=5, 
                                 noise_std=pi/30,
                                 bias_rate_stds=[0.1, 0.1],
                                 sensor=s)
    
    for t in 0:time_interval:test_time
      draw(w)
      draw!(m)
      draw!(r)
    end

    actual = r.pose
    est = r.agent.estimator.estimated_pose
    diff = sqrt((actual[1] - est[1])^2 + (actual[2] - est[2])^2)
    println("Actual:$(actual), Est:$(est), Diff:$(diff)")
    if diff <= 1.0
      return true
    else
      return false
    end
  end

  function main(test_num=1000)
    convergence_count = 0
    result = false

    for test in 1:test_num
      println("test: $(test)")
      result = single_test(max_num=10000)
      if result == true
        convergence_count += 1
      end
    end

    println("Global Kld Mcl Accuracy: $(convergence_count)/$(test_num)")
  end
end