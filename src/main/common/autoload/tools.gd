extends Node


func move_towards_target(player: CharacterBody2D, speed: float, current_position: Vector2, target_position: Vector2, delta: float) -> Vector2:
	# 计算目标方向和距离
	var direction_to_target = (target_position - current_position).normalized()
	var distance_to_target = current_position.distance_to(target_position)
	
	# 计算基础移动步长
	var base_movement_step = speed * delta
	var player_velocity = player.velocity
	# 根据父节点的速度调整实际移动步长
	var adjusted_movement_step = calculate_adjusted_movement_step(player_velocity, speed, direction_to_target, base_movement_step, delta)
	
	var new_global_position
	
	# 如果距离小于或等于调整后的步长，直接到达目标位置
	if distance_to_target <= adjusted_movement_step.length():
		new_global_position = target_position
	else:
		current_position += adjusted_movement_step
		new_global_position = current_position
	return new_global_position

# 计算考虑父节点速度后的调整移动步长
func calculate_adjusted_movement_step(parentVelocity:Vector2, speed: float, direction: Vector2, base_step: float, delta: float) -> Vector2:
	if not parentVelocity.is_zero_approx():
		var velocity_relative_to_parent = (direction * speed) - parentVelocity
		return velocity_relative_to_parent * delta
	else:
		return direction * base_step
