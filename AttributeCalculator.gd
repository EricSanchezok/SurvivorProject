class_name AttributeCalculator
extends Node


func _ready() -> void:
	'''
	初始化武器
	:return: void
	'''
	_update_parameters()
	playerStats.connect("stats_changed", _on_stats_changed)


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 玩家属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var player: CharacterBody2D
var playerStats: Node

var player_physical_attack_power: float
var player_magic_attack_power: float
var player_damage: float = 0.0 # 能够造成的总伤害
var player_attack_range: float
var player_attack_speed: float
var player_rotation_speed: float
var player_attack_wait_time: float
var player_knockback: float
var player_critical_hit_rate: float
var player_critical_damage: float
var player_number_of_projectiles: int
var player_projectile_speed: float


func _update_parameters() -> void:
	'''
	更新武器的属性

	:return: void
	'''
	player.physical_attack_power = owner.base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	player_magic_attack_power = owner.base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier

	player_attack_range = owner.base_attack_range * playerStats.attack_range_multiplier
	player_searching_shape_2d.shape.radius = owner.attack_range
	player_attack_speed = owner.base_attack_speed * playerStats.attack_speed_multiplier
	player_animation_player.speed_scale = playerStats.attack_speed_multiplier
	player_rotation_speed = owner.base_rotation_speed * playerStats.attack_speed_multiplier
	player_attack_wait_time = owner.base_attack_wait_time / playerStats.attack_speed_multiplier
	player_attack_wait_timer.wait_time = attack_wait_time
	player_knockback = owner.base_knockback * playerStats.knockback_multiplier
	player_critical_hit_rate=owner.base_critical_hit_rate + playerStats.critical_hit_rate
	player_critical_damage = owner.base_critical_damage + playerStats.critical_damage
	player_number_of_projectiles=owner.base_number_of_projectiles + playerStats.number_of_projectiles
	player_projectile_speed = owner.base_projectile_speed * playerStats.projectile_speed_multiplier
	
	player_damage = physical_attack_power + magic_attack_power
	
	player_explosion_range = owner.base_explosion_range * playerStats.attack_range_multiplier
	player_magazine = owner.base_magazine + playerStats.number_of_projectiles


func _on_stats_changed() -> void:
	_update_parameters()
