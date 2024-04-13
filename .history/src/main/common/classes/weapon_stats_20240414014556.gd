class_name WeaponStats
extends Node



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
@export var max_health_multiplier: float = 1.0
# 生命恢复倍率
@export var health_regeneration_multiplier: float = 1.0
# 移动速度倍率
@export var movement_speed_multiplier: float = 1.0
# 总攻击力倍率
@export var attack_power_multiplier: float = 1.0
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


@export var base_physical_attack_power: float = 2.0
@export var base_magic_attack_power: float = 0.0

@export var base_attack_range: float = 100.0
@export var base_attack_wait_time: float = 3.0

@export var base_projectile_speed: float = 150.0
@export var base_rotation_speed: float = 8.0

@export var base_knockback: float = 100.0

Farthest distance from player


