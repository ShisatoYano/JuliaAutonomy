# test global mcl accuracy
# particle num can be set as input variable
# test count condition: 1000

module TestGlobalMclAccuracy
  include(joinpath(split(@__FILE__, "src")[1], "src/localization/particle_filter/global_mcl/anime_global_mcl.jl"))

  function main(num = 10)
    ok_count = 0
    result = false
    for test in 1:1000
      println("test count: $(test)")
      result = AnimeGlobalMcl.main(particle_num=num, is_test=true)
      if result == true
        ok_count += 1
      end
    end
    println("Particle Num:$(num), Accuracy:$(ok_count)/1000")
  end
end