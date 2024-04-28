class_name EnemyStats
extends Node

signal health_changed

# 最大生命值
@export var max_health: float = 10
# 生命恢复
@export var base_health_regeneration: float = 0.0
# 移动速度
@export var base_speed_movement: float = 20.0
# 基础攻击力
@export var base_damage: float = 1.0
# 基础击退抗性
@export var base_knockback_resistance: float = 0.0
#基础减速抗性
@export var base_deceleration_resistance: float = 0.0
#基础冰冻抗性
@export var base_freezing_resistance: float = 0.0

@onready var health: float = max_health:
	set(v):
		v = clampf(v, 0, max_health)
		if health == v:
			return
		health = v
		health_changed.emit()

var health_regeneration: float = base_health_regeneration
var speed_movement: float = base_speed_movement
var damage: float = base_damage
var knockback_resistance: float = base_knockback_resistance
var deceleration_resistance: float = base_deceleration_resistance
var freezing_resistance: float = base_freezing_resistance
