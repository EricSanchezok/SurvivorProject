class_name Sword
extends Node2D

# 基础物理攻击力
@export var physical_attack_power: float = 3.0
# 基础魔法攻击力
@export var magic_attack_power: float = 0.5
# 基础攻击范围
@export var attack_range: float = 100.0
# 基础攻击速度(武器飞行的速度)
@export var attack_speed: float = 100.0
# 基础击退
@export var knockback: float = 20.0


@onready var area_2d: Area2D = $Area2D

var enemies: Array = []
var is_attacking: bool = false
var target: CharacterBody2D = null

var current_time: float = 0.0
var attack_windup: bool = false
var attack_backswing: bool = false

func _process(delta: float) -> void:
	if not is_attacking:
		target = get_nearst_enemy()
		if target:
			current_time = 0.0
			is_attacking = true
			attack_windup = true
			attack_backswing = false
	else:
		var direction = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
		var distance = global_position.distance_to(target.global_position)
		var target_direction := (target.global_position - global_position).normalized()
		rotation = lerp_angle(rotation, target_direction.angle() - PI/2, 0.07)

		var all_time = 1.0 / attack_speed
		var t = min(current_time / all_time, 1.0)
		if t < 1.0:
			var start_control_point = global_position + direction * 2.0
			var next_point = global_position.bezier_interpolate(start_control_point, target.global_position, target.global_position, t)
			global_position = next_point
			current_time += delta
		else:
			is_attacking = false
			target.take_damage(physical_attack_power, magic_attack_power, knockback, direction)
			current_time = 0.0

	


func get_nearst_enemy() -> CharacterBody2D:
	'''
	获取最近的敌人
	
	:return: CharacterBody2D 最近的敌人
	'''
	var nearst_enemy: CharacterBody2D = null
	var nearst_distance: float = attack_range
	for enemy in enemies:
		var distance = area_2d.global_position.distance_to(enemy.global_position)
		if distance < nearst_distance:
			nearst_enemy = enemy
			nearst_distance = distance
	return nearst_enemy

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy') and not enemies.has(body):
		enemies.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('enemy') and enemies.has(body):
		enemies.erase(body)
		
