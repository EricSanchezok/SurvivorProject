extends Node

func are_angles_close(angle1: float, angle2: float, tolerance: float = 0.01) -> bool:
	'''
	判断两个角度是否接近

	:param angle1: 角度1
	:param angle2: 角度2
	:param tolerance: 容忍度
	:return: 是否接近
	'''
	var difference = fmod(angle1 - angle2, 2 * PI) # 计算两个角度的差值并使用2π进行模运算
	# 将差值调整到[-π, π]范围内
	if difference > PI:
		difference -= 2 * PI
	elif difference < -PI:
		difference += 2 * PI

	print(difference)
	
	# 判断调整后的差值是否在容忍度范围内
	return abs(difference) <= tolerance


func get_nearest_enemy(_attack_range: float, enemiesList: Array, self_position: Vector2) -> CharacterBody2D:
	'''
	获取最近的敌人

	:param _attack_range: 攻击范围
	:param enemiesList: 敌人列表
	:param self_position: 自身位置
	:return: 最近的敌人
	'''
	var nearestEnemy: CharacterBody2D = null
	var nearestDistance: float = _attack_range
	for enemy in enemiesList:
		var distance = enemy.global_position.distance_to(self_position)
		if distance < nearestDistance:
			nearestEnemy = enemy
			nearestDistance = distance
	return nearestEnemy

func is_success(success_rate: float) -> bool:
	'''
	根据成功率判断是否成功

	:param success_rate: 成功率 0-1
	:return: 是否成功
	'''
	return randf() <= success_rate


func move_towards_target(player: CharacterBody2D, speed: float, current_position: Vector2, target_position: Vector2, delta: float) -> Vector2:
	'''
	根据目标位置移动到目标位置

	:param player: 玩家节点
	:param speed: 移动速度
	:param current_position: 当前位置
	:param target_position: 目标位置
	:param delta: 时间增量
	:return: 新的全局位置
	'''
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

func calculate_adjusted_movement_step(parentVelocity:Vector2, speed: float, direction: Vector2, base_step: float, delta: float) -> Vector2:
	'''
	计算考虑父节点速度后的调整移动步长

	:param parentVelocity: 父节点速度
	:param speed: 移动速度
	:param direction: 移动方向
	:param base_step: 基础移动步长
	:param delta: 时间增量
	:return: 调整后的移动步长
	'''
	if not parentVelocity.is_zero_approx():
		var velocity_relative_to_parent = (direction * speed) - parentVelocity
		return velocity_relative_to_parent * delta
	else:
		return direction * base_step
