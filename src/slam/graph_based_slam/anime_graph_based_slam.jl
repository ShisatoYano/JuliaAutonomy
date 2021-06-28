# module for simulate and draw graph based slam

module AnimeGraphBasedSlam
  using Plots
  pyplot()
  
  # read logged trajectory and observation data
  function read_data()
    pose_list = Dict() # trajectory
    obsrv_list = Dict() # observation

    log_path = "src/slam/graph_based_slam/traj_obsrv_log.txt"
    open(joinpath(split(@__FILE__, "src")[1], log_path), "r") do fp
      for line in eachline(fp)
        tmp = split(line)
        
        type = tmp[1]
        step = tmp[2]
        if type == "x" # [x, y, theta]
          pose_list[step] = [parse(Float64, tmp[3]), parse(Float64, tmp[4]), parse(Float64, tmp[5])]
        elseif type == "z" # (id, [distance, direction, orientation])
          if !haskey(obsrv_list, step)
            obsrv_list[step] = []
          end
          push!(obsrv_list[step], (parse(Int64, tmp[3]), [parse(Float64, tmp[4]), parse(Float64, tmp[5]), parse(Float64, tmp[6])]))
        end
      end
    end

    return pose_list, obsrv_list
  end

  function make_axis()
    plot([], [], aspect_ratio=true, xlabel="X", ylabel="Y",
         xlims=(-5.0, 5.0), ylims=(-5.0, 5.0), legend=false)
  end

  function draw(pose_list, obsrv_list)
    make_axis()
  end

  function main()
    pose_list, obsrv_list = read_data()
    
    draw(pose_list, obsrv_list)
  end
end