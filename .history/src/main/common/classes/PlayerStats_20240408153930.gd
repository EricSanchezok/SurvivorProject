class_name PlayerStats
extends Node

signal health_changed

signal parameters_changed



# 基础最大生命值
@export var base_max_health: float = 10:
	set(v):
		if base_max_health == v:
			return
		base_max_health = v
		max_health_changed.emit()
# 基础生命恢复
@export var base_health_regeneration: float = 0.0:
	set(v):
		if base_health_regeneration == v:
			return
		base_health_regeneration = v
		health_regeneration_changed.emit()
# 基础移动速度
@export var base_movement_speed: float = 100:
	set(v):
		if base_movement_speed == v:
			return
		base_movement_speed = v
		movement_speed_changed.emit()
# 暴击率
@export var critical_hit_rate: float = 0.0:
	set(v):
		if critical_hit_rate == v:
			return
		critical_hit_rate = v
		critical_hit_rate_changed.emit()
# 暴击伤害
@export var critical_damage: float = 1.5:
	set(v):
		if critical_damage == v:
			return
		critical_damage = v
		critical_damage_changed.emit()
# 发射物数量
@export var number_of_projectiles: int = 1:
	set(v):
		if number_of_projectiles == v:
			return
		number_of_projectiles = v
		number_of_projectiles_changed.emit()
# 伤害减免率
@export var damage_reduction_rate: float = 0.0:
	set(v):
		if damage_reduction_rate == v:
			return
		damage_reduction_rate = v
		damage_reduction_rate_changed.emit()



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
@export var physical_attack_power_multiplier: float = 1.0:
	set(v):
		if physical_attack_power_multiplier == v:
			return
		physical_attack_power_multiplier = v
		physical_attack_power_multiplier_changed.emit()
# 魔法攻击力倍率
@export var magic_attack_power_multiplier: float = 1.0:
	set(v):
		if magic_attack_power_multiplier == v:
			return
		magic_attack_power_multiplier = v
		magic_attack_power_multiplier_changed.emit()
# 攻击范围倍率
@export var attack_range_multiplier: float = 1.0:
	set(v):
		if attack_range_multiplier == v:
			return
		attack_range_multiplier = v
		attack_range_multiplier_changed.emit()
# 攻击速度倍率
@export var attack_speed_multiplier: float = 1.0:
	set(v):
		if attack_speed_multiplier == v:
			return
		attack_speed_multiplier = v
		attack_speed_multiplier_changed.emit()
# 击退倍率
@export var knockback_multiplier: float = 1.0:
	set(v):
		if knockback_multiplier == v:
			return
		knockback_multiplier = v
		knockback_multiplier_changed.emit()
# 发射物速度倍率
@export var projectile_speed_multiplier: float = 1.0:
	set(v):
		if projectile_speed_multiplier == v:
			return
		projectile_speed_multiplier = v
		projectile_speed_multiplier_changed.emit()
# 经验获取倍率
@export var experience_gain_multiplier: float = 1.0:
	set(v):
		if experience_gain_multiplier == v:
			return
		experience_gain_multiplier = v
		experience_gain_multiplier_changed.emit()





@onready var health: float = base_max_health * max_health_multiplier:
	set(v):
		v = clampf(v, 0, base_max_health * max_health_multiplier)
		if health == v:
			return
		health = v
		health_changed.emit()
