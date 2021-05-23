function observation_function(sns_pose::Array, obj_pose::Array)
  diff_x = obj_pose[1] - sns_pose[1]
  diff_y = obj_pose[2] - sns_pose[2]
  phi = atan(diff_y, diff_x) - sns_pose[3]
  while phi >= pi
    phi -= 2 * pi
  end
  while phi < -pi
    phi += 2 * pi
  end
  return [hypot(diff_x, diff_y), phi]
end