class_name EnemyStats
extends Node

signal health_changed

# 最大生命值
@export var max_health: float = 10
# 生命恢复
@export var health_regeneration: float = 0.0
# 移动速度
@export var speed_movement: float = 20.0
# 基础攻击力
@export var damage: float = 1.0
# 基础击退抗性
@export var knockback_resistance: float = 0.0

@onready var health: float = max_health:
	set(v):
		v = clampf(v, 0, max_health)
		if health == v:
			return
		health = v
		health_changed.emit()
