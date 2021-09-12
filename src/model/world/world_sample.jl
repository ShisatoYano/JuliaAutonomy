# sample to show world module's graph
module WorldSample
  # include external modules
  include(joinpath(split(@__FILE__, "src")[1], "src/model/world/puddle_world.jl"))

  # main function
  # show world's graph
  function main(delta_time=0.1, end_time=5; is_test=false)
    # save path of output
    path = "src/model/world/world_sample.gif"

    # create instance
    world = PuddleWorld(-5.0, 5.0, -5.0, 5.0,
                        delta_time=delta_time,
                        end_time=end_time,
                        is_test=is_test,
                        save_path=path)
    
    # draw graph
    draw(world)
  end
end