class_name Sword
extends Node2D




# 基础物理攻击力
@export var physical_attack_power: float = 3.0
# 基础魔法攻击力
@export var magic_attack_power: float = 0.5
# 基础攻击范围
@export var attack_range: float = 100.0
# 基础攻击速度(每秒攻击次数)
@export var attack_speed: float = 1.0
# 基础击退
@export var knockback: float = 20.0


@onready var area_2d: Area2D = $Area2D

var enemys: Array = []

func _process(delta: float) -> void:
	var target = get_nearst_enemy()

func get_nearst_enemy() -> CharacterBody2D:
	'''
	获取最近的敌人
	
	:return: Node2D
	'''
	var nearst_enemy: Node2D = null
	var nearst_distance: float = attack_range
	for enemy in enemys:
		var distance = area_2d.global_position.distance_to(enemy.global_position)
		if distance < nearst_distance:
			nearst_enemy = enemy
			nearst_distance = distance
	return nearst_enemy

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy') and not enemys.has(body):
		enemys.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('enemy') and enemys.has(body):
		enemys.erase(body)
		
