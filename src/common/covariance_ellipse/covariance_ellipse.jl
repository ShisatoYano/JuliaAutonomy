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

  t = 0:1:(pi * 2)
  a = sqrt(eig_vals[big_idx])
  b = sqrt(eig_vals[small_idx])
  x = [a * n * cos(it) for it in t]
  y = [b * n * sin(it) for it in t]
  angle = atan(eig_vecs[big_idx, 2], eig_vecs[big_idx, 1])
  rot_mat = [cos(angle) sin(angle); -sin(angle) cos(angle)]
  println(x)
  println(y)
  println(rot_mat * [x y]')
end