extends Node2D

var enemy: EnemyBase

func _ready() -> void:
	print(get_random_direction(Vector2(0, 0), 30).angle()*180/3.1415)

func get_random_direction(base_direction: Vector2, angle_range: float) -> Vector2:
	'''
	获取随机方向

	:param base_direction: 基准方向
	:param angle_range: 角度范围

	:return: 随机方向
	'''
	var base_angle = base_direction.angle()
	
	var half_angle_range = angle_range * 0.5
	var random_angle = randf_range(-half_angle_range, half_angle_range)
	
	var new_angle = base_angle + deg_to_rad(random_angle)

	return Vector2(cos(new_angle), sin(new_angle))
