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
# 基础生命恢复
@export var base_health_regeneration: float = 0.0:
	set(v):
		if base_health_regeneration == v:
			return
		base_health_regeneration = v
# 基础移动速度
@export var base_movement_speed: float = 100:
	set(v):
		if base_movement_speed == v:
			return
		base_movement_speed = v
# 暴击率
@export var critical_hit_rate: float = 0.0:
	set(v):
		if critical_hit_rate == v:
			return
		owner.abc.set_player_attribute(owner.abc.Attributes.CRITICAL_HIT_RATE,v-critical_hit_rate)
		critical_hit_rate = v
# 暴击伤害
@export var critical_damage: float = 0:
	set(v):
		if critical_damage == v:
			return
		owner.abc.set_player_attribute(owner.abc.Attributes.CRITICAL_DAMAGE,v-critical_damage)
		critical_damage = v
# 发射物数量
@export var number_of_projectiles: int = 0:
	set(v):
		if number_of_projectiles == v:
			return
		owner.abc.set_player_attribute(owner.abc.Attributes.NUMBER_OF_PROJECTILES,v-number_of_projectiles)
		number_of_projectiles = v
# 伤害减免率
@export var damage_reduction_rate: float = 0.0:
	set(v):
		if damage_reduction_rate == v:
			return
		damage_reduction_rate = v



# 最大生命值倍率
@export var max_health_multiple: float = 1.0:
	set(v):
		if max_health_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.HEALTH,v-max_health_multiple)
		max_health_multiple = v
# 生命恢复倍率
@export var health_regeneration_multiple: float = 1.0:
	set(v):
		if health_regeneration_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.HEALTH_REGENERATION,v-health_regeneration_multiple)
		health_regeneration_multiple = v
# 移动速度倍率
@export var movement_speed_multiple: float = 1.0:
	set(v):
		if movement_speed_multiple == v:
			return
		movement_speed_multiple = v
# 物理攻击力倍率
@export var power_physical_multiple: float = 0:
	set(v):
		if power_physical_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.POWER_PHYSICAL,v-power_physical_multiple)
		power_physical_multiple = v
# 魔法攻击力倍率
@export var power_magic_multiple: float = 0:
	set(v):
		if power_magic_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.POWER_MAGIC,v-power_magic_multiple)
		power_magic_multiple = v

# 索敌范围倍率
@export var radius_search_multiple: float = 0:
	set(v):
		if radius_search_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.RADIUS_SEARCH,v-radius_search_multiple)
		radius_search_multiple = v
# 攻击范围倍率
@export var range_attack_multiple: float = 0:
	set(v):
		if range_attack_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.RANGE_ATTACK,v-range_attack_multiple)
		range_attack_multiple = v
# 攻击速度倍率
@export var time_cooldown_multiple: float = 0:
	set(v):
		if time_cooldown_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.TIME_COOLDOWN,v-time_cooldown_multiple)
		time_cooldown_multiple = v
# 击退倍率
@export var knockback_multiple: float = 0:
	set(v):
		if knockback_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.KNOCKBACK,v-knockback_multiple)
		knockback_multiple = v
# 武器飞行速度倍率
@export var speed_fly_multiple: float = 0:
	set(v):
		if speed_fly_multiple == v:
			return
		owner.abc.set_player_attribute(owner.abc.SPEED_FLY,v-speed_fly_multiple)
		speed_fly_multiple = v
# 经验获取倍率
@export var experience_gain_multiple: float = 1.0:
	set(v):
		if experience_gain_multiple == v:
			return
		experience_gain_multiple = v


@onready var health: float = base_max_health * max_health_multiple:
	set(v):
		v = clampf(v, 0, base_max_health * max_health_multiple)
		if health == v:
			return
		health = v
		health_changed.emit()
