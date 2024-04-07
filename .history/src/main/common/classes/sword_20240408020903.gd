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



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is_in_group('enemy') and not enemys.has(body):
		enemys.append(body)
		body.hurt(physical_attack_power, magic_attack_power, knockback)
		# print('attack', body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
