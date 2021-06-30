# module for simulate and draw graph based slam

module AnimeGraphBasedSlam
  # packages
  using Combinatorics
  using Plots
  pyplot()

  # external modules
  include(joinpath(split(@__FILE__, "src")[1], "src/slam/graph_based_slam/obsrv_edge.jl"))
  
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

  function draw_observation(pose_list, obsrv_list)
    for step in 0:length(pose_list)-1
      step_str = string(step)
      if haskey(obsrv_list, step_str)
        for obsrv in obsrv_list[step_str]
          x, y, theta = pose_list[step_str][1], pose_list[step_str][2], pose_list[step_str][3]
          dist, dir = obsrv[2][1], obsrv[2][2]
          mx = x + dist * cos(theta + dir)
          my = y + dist * sin(theta + dir)
          plot!([x, mx], [y, my], color="pink", legend=false,
                aspect_ratio=true, alpha=0.5)
        end
      end
    end
  end

  function draw_trajectory(pose_list)
    x_list = [pose_list[string(step)][1] for step in 0:length(pose_list)-1]
    y_list = [pose_list[string(step)][2] for step in 0:length(pose_list)-1]
    scatter!(x_list, y_list, markersize=2, markercolor="black")
    plot!(x_list, y_list, linewidth=0.5, color="black")
  end

  function make_edges(pose_list, obsrv_list)
    # record time and observation
    landmark_keys_list = Dict()
    for step in 0:length(pose_list)-1
      step_str = string(step)
      for obsrv in obsrv_list[step_str]
        id_str = string(obsrv[1])
        if !haskey(landmark_keys_list, id_str)
          landmark_keys_list[id_str] = []
        end
        push!(landmark_keys_list[id_str], (step, obsrv))
      end
    end

    edges = []
    for key_id in keys(landmark_keys_list)
      step_pairs =[pair for pair in combinations(landmark_keys_list[key_id], 2)]
      for pair in step_pairs
        push!(edges, ObsrvEdge(pair[1][1], pair[2][1], pair[1][2], pair[2][2], pose_list))
      end
    end

    return edges
  end

  function draw_edges(edges)
    for e in edges
      plot!([e.x1[1], e.x2[1]], [e.x1[2], e.x2[2]], color="red", alpha=0.5)
    end
  end

  function draw(pose_list, obsrv_list, edges)
    make_axis()
    draw_observation(pose_list, obsrv_list)
    draw_edges(edges)
    draw_trajectory(pose_list)
  end

  function main(is_test=false)
    pose_list, obsrv_list = read_data()

    edges = make_edges(pose_list, obsrv_list)
    
    draw(pose_list, obsrv_list, edges)

    if is_test == false
      save_path = joinpath(split(@__FILE__, "src")[1], "src/slam/graph_based_slam/obsrv_edges_log.png")
      savefig(save_path)
    end
  end
end