using Plots, LinearAlgebra
pyplot()

function draw_covariance_ellipse!(pose, cov, n)
  pose_xy = pose[1:2]
  cov_xy = cov[1:2, 1:2]
  
  eig_vals, eig_vecs = eigen(cov_xy)
  if eig_vals[1] >= eig_vals[2]
    big_idx = 1
    small_idx = 2
  else
    big_idx = 2
    small_idx = 1
  end

  # 3 sigma covariance, x-y
  t = 0:0.1:(pi * 2 + 0.1)
  a = sqrt(eig_vals[big_idx])
  b = sqrt(eig_vals[small_idx])
  x = [a * n * cos(it) for it in t]
  y = [b * n * sin(it) for it in t]
  angle = atan(eig_vecs[big_idx, 2], eig_vecs[big_idx, 1])
  rot_mat = [cos(angle) sin(angle); -sin(angle) cos(angle)]
  rot_xy = rot_mat * [x y]'
  px = rot_xy[1, begin:end] .+ pose_xy[1]
  py = rot_xy[2, begin:end] .+ pose_xy[2]
  plot!(px, py, color="blue", legend=false, 
        aspect_ratio=true, alpha=0.5)
  
  # 3 sigma covariance, theta
  pose_theta = pose[3]
  theta_3_sigma = sqrt(cov[3, 3]) * n
  xs = [pose_xy[1] + cos(pose_theta - theta_3_sigma),
        pose_xy[1],
        pose_xy[1] + cos(pose_theta + theta_3_sigma)]
  ys = [pose_xy[2] + sin(pose_theta - theta_3_sigma),
        pose_xy[2],
        pose_xy[2] + sin(pose_theta + theta_3_sigma)]
  plot!(xs, ys, color="blue", legend=false, 
        aspect_ratio=true, alpha=0.5)
end