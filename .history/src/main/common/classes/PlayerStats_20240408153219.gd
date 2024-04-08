class_name PlayerStats
extends Node

signal health_changed
signal max_health_multiplier_changed
signal health_regeneration_multiplier_changed
signal movement_speed_multiplier_changed
signal attack_power_multiplier_changed
signal physical_attack_power_multiplier_changed
signal magic_attack_power_multiplier_changed
signal attack_range_multiplier_changed
signal attack_speed_multiplier_changed
signal knockback_multiplier_changed
signal projectile_speed_multiplier_changed
signal experience_gain_multiplier_changed


# 基础最大生命值
@export var base_max_health: float = 10
# 基础生命恢复
@export var base_health_regeneration: float = 0.0
# 基础移动速度
@export var base_movement_speed: float = 100
# 暴击率
@export var critical_hit_rate: float = 0.0
# 暴击伤害
@export var critical_damage: float = 1.5
# 发射物数量
@export var number_of_projectiles: int = 1
# 伤害减免率
@export var damage_reduction_rate: float = 0.0



# 最大生命值倍率
@export var max_health_multiplier: float = 1.0:
	set(v):
		if max_health_multiplier == v:
			return
		max_health_multiplier = v
		max_health_multiplier_changed.emit()
# 生命恢复倍率
@export var health_regeneration_multiplier: float = 1.0:
	set(v):
		if health_regeneration_multiplier == v:
			return
		health_regeneration_multiplier = v
		health_regeneration_multiplier_changed.emit()
# 移动速度倍率
@export var movement_speed_multiplier: float = 1.0:
	set(v):
		if movement_speed_multiplier == v:
			return
		movement_speed_multiplier = v
		movement_speed_multiplier_changed.emit()
# 总攻击力倍率
@export var attack_power_multiplier: float = 1.0:
	set(v):
		if attack_power_multiplier == v:
			return
		attack_power_multiplier = v
		attack_power_multiplier_changed.emit()
# 物理攻击力倍率
@export var physical_attack_power_multiplier: float = 1.0
# 魔法攻击力倍率
@export var magic_attack_power_multiplier: float = 1.0
# 攻击范围倍率
@export var attack_range_multiplier: float = 1.0
# 攻击速度倍率
@export var attack_speed_multiplier: float = 1.0
# 击退倍率
@export var knockback_multiplier: float = 1.0
# 发射物速度倍率
@export var projectile_speed_multiplier: float = 1.0
# 经验获取倍率
@export var experience_gain_multiplier: float = 1.0





@onready var health: float = base_max_health * max_health_multiplier:
	set(v):
		v = clampf(v, 0, base_max_health * max_health_multiplier)
		if health == v:
			return
		health = v
		health_changed.emit()
