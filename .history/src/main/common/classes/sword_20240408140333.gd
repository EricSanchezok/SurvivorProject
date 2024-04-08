class_name Sword
extends Node2D

# 基础物理攻击力
@export var physical_attack_power: float = 3.0
# 基础魔法攻击力
@export var magic_attack_power: float = 0.5
# 基础攻击范围
@export var attack_range: float = 100.0
# 基础攻击速度(一秒钟攻击的次数)
@export var attack_speed: float = 1.0
# 基础击退
@export var knockback: float = 20.0


@onready var area_2d: Area2D = $Area2D

var enemies: Array = []
var is_attacking: bool = false
var target: CharacterBody2D = null

var current_time: float = 0.0

func _process(delta: float) -> void:
	if not is_attacking:
		target = get_nearst_enemy()
		if target:
			is_attacking = true
	else:
		var dir := (target.global_position - global_position).normalized()
		rotation = lerp_angle(rotation, dir.angle() - PI/2, 0.1)

		var all_time = 1.0 / attack_speed
		var t = current_time / all_time

	


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
		
