class_name PlayerStats
extends Node

signal health_changed
signal stats_changed



# 基础最大生命值
@export var base_max_health: float = 10:
	set(v):
		if base_max_health == v:
			return
		base_max_health = v
		stats_changed.emit()
# 基础生命恢复
@export var base_health_regeneration: float = 0.0:
	set(v):
		if base_health_regeneration == v:
			return
		base_health_regeneration = v
		stats_changed.emit()
# 基础移动速度
@export var base_movement_speed: float = 100:
	set(v):
		if base_movement_speed == v:
			return
		base_movement_speed = v
		stats_changed.emit()
# 暴击率
@export var critical_hit_rate: float = 0.0:
	set(v):
		if critical_hit_rate == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("critical_hit_rate","absolute",v-critical_hit_rate)
		critical_hit_rate = v
		stats_changed.emit()
# 暴击伤害
@export var critical_damage: float = 0:
	set(v):
		if critical_damage == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("critical_hit_rate","absolute",v-critical_hit_rate)
		critical_damage = v
		stats_changed.emit()
# 发射物数量
@export var number_of_projectiles: int = 0:
	set(v):
		if number_of_projectiles == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("number_of_projectiles","absolute",v-critical_hit_rate)
		number_of_projectiles = v
		stats_changed.emit()
# 伤害减免率
@export var damage_reduction_rate: float = 0.0:
	set(v):
		if damage_reduction_rate == v:
			return
		damage_reduction_rate = v
		stats_changed.emit()



# 最大生命值倍率
@export var max_health_multiplier: float = 1.0:
	set(v):
		if max_health_multiplier == v:
			return
		max_health_multiplier = v
		stats_changed.emit()
# 生命恢复倍率
@export var health_regeneration_multiplier: float = 1.0:
	set(v):
		if health_regeneration_multiplier == v:
			return
		health_regeneration_multiplier = v
		stats_changed.emit()
# 移动速度倍率
@export var movement_speed_multiplier: float = 1.0:
	set(v):
		if movement_speed_multiplier == v:
			return
		movement_speed_multiplier = v
		stats_changed.emit()
# 总攻击力倍率
@export var power_multiplier: float = 0:
	set(v):
		if power_multiplier == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("power_physical","percent",v-critical_hit_rate)
			weapon.modify_attribute("power_magic","percent",v-critical_hit_rate)
		power_multiplier = v
		stats_changed.emit()
# 物理攻击力倍率
@export var power_physical_multiplier: float = 0:
	set(v):
		if power_physical_multiplier == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("power_physical","percent",v-critical_hit_rate)
		power_physical_multiplier = v
		stats_changed.emit()
# 魔法攻击力倍率
@export var power_magic_multiplier: float = 0:
	set(v):
		if power_magic_multiplier == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("power_magic","percent",v-critical_hit_rate)
		power_magic_multiplier = v
		stats_changed.emit()
# 攻击范围倍率
@export var range_attack_multiplier: float = 0:
	set(v):
		if range_attack_multiplier == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("range_attack","percent",v-critical_hit_rate)
		range_attack_multiplier = v
		stats_changed.emit()
# 攻击速度倍率
@export var time_cooldown_multiplier: float = 0:
	set(v):
		if time_cooldown_multiplier == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("time_cooldown","percent",v-critical_hit_rate)
		time_cooldown_multiplier = v
		stats_changed.emit()
# 击退倍率
@export var knockback_multiplier: float = 0:
	set(v):
		if knockback_multiplier == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("knockback","percent",v-critical_hit_rate)
		knockback_multiplier = v
		stats_changed.emit()
# 武器飞行速度倍率
@export var speed_fly_multiplier: float = 0:
	set(v):
		if speed_fly_multiplier == v:
			return
		for weapon in owner.weapons:
			weapon.modify_attribute("speed_fly","percent",v-critical_hit_rate)
		speed_fly_multiplier = v
		stats_changed.emit()
# 经验获取倍率
@export var experience_gain_multiplier: float = 1.0:
	set(v):
		if experience_gain_multiplier == v:
			return
		experience_gain_multiplier = v
		stats_changed.emit()


@onready var health: float = base_max_health * max_health_multiplier:
	set(v):
		v = clampf(v, 0, base_max_health * max_health_multiplier)
		if health == v:
			return
		health = v
		health_changed.emit()
