class_name EnemyStats
extends Node

signal health_changed

# 基础最大生命值
@export var base_max_health: float = 10
# 基础生命恢复
@export var base_health_regeneration: float = 0.0
# 基础移动速度
@export var base_movement_speed: float = 40.0
# 基础移动加速度
@export var base_movement_acceleration: float = 100.0
# 基础攻击力
@export var attack_power: float = 1.0
# 基础击退抗性
@export var knockback_resistance: float = 0.0

@onready var health: float = base_max_health:
	set(v):
		v = clampf(v, 0, base_max_health)
		if health == v:
			return
		health = v
		health_changed.emit()
