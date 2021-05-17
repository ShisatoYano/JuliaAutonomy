# calculating error between two poses

using Plots
pyplot()

function calc_lon_lat_error(pose::Array, pose_ref::Array)
  error_x = pose[1] - pose_ref[1]
  error_y = pose[2] - pose_ref[2]
  error_theta = pose[3] - pose_ref[3]
  error_lon = cos(pose_ref[3])*error_x + sin(pose_ref[3])*error_y
  error_lat = -sin(pose_ref[3])*error_x + cos(pose_ref[3])*error_y
  return [round(error_lon, digits=2), round(error_lat, digits=2), 
          round(error_theta, digits=2)]
end

function draw_lon_lat_error!(pose::Array, pose_ref::Array)
  error = calc_lon_lat_error(pose, pose_ref)
  annotate!(pose_ref[1], pose_ref[2]+0.1, 
            text("($(error[1]), $(error[2]), $(error[3]))", 
            :left, 8))
end