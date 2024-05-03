extends Node

func are_angles_close(angle1: float, angle2: float, tolerance: float = 0.1) -> bool:
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

