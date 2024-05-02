class_name WeaponBase
extends CharacterBody2D


var slot: Marker2D
var slot_index: int
var player: CharacterBody2D
var player_stats: Node 

var enemies: Array = []
var target: EnemyBase

@onready var weapon_icon: Sprite2D = $Graphics/Sprite2D # 武器图标
@onready var weapon_stats: WeaponStats = $WeaponStats
@onready var weapon_level: int = 1: # 武器等级
	set(v):
		weapon_level = v
		match weapon_level:
			1:
				weapon_icon.material.set_shader_parameter("line_color", Color.WHITE)
			2:
				weapon_icon.material.set_shader_parameter("line_color", Color.BLUE)
			3:
				weapon_icon.material.set_shader_parameter("line_color", Color.RED)
	


func _ready() -> void:
	# 唯一化 weapon_icon 的材质
	var materialTemp = weapon_icon.material.duplicate()
	weapon_icon.material = materialTemp

func get_nearest_enemy(is_self: bool = false) -> CharacterBody2D:
	'''
	获取最近的敌人
	
	:return: 最近的敌人
	'''
	var nearestEnemy: CharacterBody2D = null
	var nearestDistance: float = pow(weapon_stats.radius_search, 2)
	var self_position = global_position if is_self else player.global_position
	for enemy in enemies:
		var distance = enemy.global_position.distance_squared_to(self_position)
		if distance < nearestDistance and not enemy.is_dead:
			nearestEnemy = enemy
			nearestDistance = distance
	return nearestEnemy

func get_random_enemy() -> CharacterBody2D:
	if enemies.size() > 0:
		return enemies.pick_random()
	else:
		return null
	
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


func sync_position(displacement: float=0.0) -> void:
	var target_position = slot.global_position - $CenterMarker2D.position.rotated(rotation)
	if displacement == 0.0:
		position = target_position
	else:
		position = position.move_toward(target_position, displacement)

func towards_target(_target: EnemyBase, angular_displacement: float=0.0, is_graphics: bool=false) -> void:
	var target_direction = _target.global_position - position
	var angle = target_direction.angle()
	if is_graphics:
		$Graphics.rotation = lerp_angle($Graphics.rotation, angle, angular_displacement)
	else:
		rotation = lerp_angle(rotation, angle, angular_displacement)
		
func get_random_position_on_circle(radius: float) -> Vector2:
	'''
	获取距离圆心固定距离的随机位置

	:return: Vector2 随机位置
	'''
	var angle = randf_range(0, 360)
	return Vector2(cos(angle), sin(angle)) * radius
	
	
func _on_search_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)

func _on_search_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)
