class_name PlayerStats
extends Node

signal health_changed
signal stats_changed
var abc = owner.abc


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
		abc.set_player_attribute(abc.Attributes.CRITICAL_HIT_RATE,v-critical_hit_rate)
		critical_hit_rate = v
		stats_changed.emit()
# 暴击伤害
@export var critical_damage: float = 0:
	set(v):
		if critical_damage == v:
			return
		abc.set_player_attribute(abc.Attributes.CRITICAL_DAMAGE,v-critical_damage)
		critical_damage = v
		stats_changed.emit()
# 发射物数量
@export var number_of_projectiles: int = 0:
	set(v):
		if number_of_projectiles == v:
			return
		abc.set_player_attribute(abc.Attributes.NUMBER_OF_PROJECTILES,v-number_of_projectiles)
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
@export var max_health: float = 1.0:
	set(v):
		if max_health == v:
			return
		max_health = v
		stats_changed.emit()
# 生命恢复倍率
@export var health_regeneration: float = 1.0:
	set(v):
		if health_regeneration == v:
			return
		health_regeneration = v
		stats_changed.emit()
# 移动速度倍率
@export var movement_speed: float = 1.0:
	set(v):
		if movement_speed == v:
			return
		movement_speed = v
		stats_changed.emit()
# 物理攻击力倍率
@export var power_physical: float = 0:
	set(v):
		if power_physical == v:
			return
		abc.set_player_attribute(abc.POWER_PHYSICAL,v-power_physical)
		power_physical = v
		stats_changed.emit()
# 魔法攻击力倍率
@export var power_magic: float = 0:
	set(v):
		if power_magic == v:
			return
		abc.set_player_attribute(abc.POWER_MAGIC,v-power_magic)
		power_magic = v
		stats_changed.emit()
# 攻击范围倍率
@export var radius_search: float = 0:
	set(v):
		if radius_search == v:
			return
		abc.set_player_attribute(abc.RANGE_ATTACK,v-radius_search)
		radius_search = v
		stats_changed.emit()
# 攻击速度倍率
@export var time_cooldown: float = 0:
	set(v):
		if time_cooldown == v:
			return
		abc.set_player_attribute(abc.TIME_COOLDOWN,v-time_cooldown)
		time_cooldown = v
		stats_changed.emit()
# 击退倍率
@export var knockback: float = 0:
	set(v):
		if knockback == v:
			return
		abc.set_player_attribute(abc.KNOCKBACK,v-knockback)
		knockback = v
		stats_changed.emit()
# 武器飞行速度倍率
@export var speed_fly: float = 0:
	set(v):
		if speed_fly == v:
			return
		abc.set_player_attribute(abc.SPEED_FLY,v-speed_fly)
		speed_fly = v
		stats_changed.emit()
# 经验获取倍率
@export var experience_gain: float = 1.0:
	set(v):
		if experience_gain == v:
			return
		experience_gain = v
		stats_changed.emit()


@onready var health: float = base_max_health * max_health:
	set(v):
		v = clampf(v, 0, base_max_health * max_health)
		if health == v:
			return
		health = v
		health_changed.emit()
