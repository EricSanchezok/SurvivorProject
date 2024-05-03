class_name EnemyStats
extends Node

# 最大生命值
@export var base_health: float = 10
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

@onready var current_health: float = base_health:
	set(v):
		v = clampf(v, 0, base_health)
		if current_health == v:
			return
		current_health = v
		$"../TextureProgressBar".value = current_health / base_health

@onready var health_regeneration: float = base_health_regeneration
@onready var speed_movement: float = base_speed_movement
@onready var damage: float = base_damage
@onready var knockback_resistance: float = base_knockback_resistance
@onready var deceleration_resistance: float = base_deceleration_resistance
@onready var freezing_resistance: float = base_freezing_resistance
