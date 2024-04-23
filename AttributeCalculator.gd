class_name AttributeCalculator
extends Node

var player: CharacterBody2D
var playerStats : Node

signal  physical_attack_power_changed
signal  magic_attack_power_changed
signal  attack_speed_changed
signal  rotation_speed_changed
signal  attack_range_changed
signal  explosion_range_changed
signal  knockback_changed
signal  critical_hit_rate_changed
signal  critical_damage_changed
signal  number_of_projectiles_changed
signal  projectile_speed_changed

func _ready() -> void:
	player = owner.player
	playerStats  = owner.playerStats

	'''
	初始化武器
	:return: void
	'''
	_player_update_parameters()
	playerStats.connect("stats_changed", _on_player_stats_changed)

func multiplication_attribute_calculator(attribute_name: String, change_type: String,value: float) -> void:
	attribute_name +=base_attribute_name * value

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 玩家属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>> 物理伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_physical_attack_power: float:
	set(v):
		if player_physical_attack_power == v:
			return
		player_physical_attack_power = v
		physical_attack_power_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 魔法伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_magic_attack_power: float:
	set(v):
		if player_magic_attack_power == v:
			return
		player_magic_attack_power = v
		physical_attack_power_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 攻击速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_attack_speed: float : 
	set(v):
		if player_attack_speed == v:
			return
		player_attack_speed = v
		attack_speed_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 攻击速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_rotation_speed: float : 
	set(v):
		if player_rotation_speed == v:
			return
		player_rotation_speed = v
		rotation_speed_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 攻击范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_attack_range: float :
	set(v):
		if player_attack_range == v:
			return
		player_attack_range = v
		attack_range_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 爆炸范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_explosion_range: float :
	set(v):
		if player_explosion_range == v:
			return
		player_explosion_range = v
		explosion_range_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 击退相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_knockback: float :
	set(v):
		if player_knockback == v:
			return
		player_knockback = v
		knockback_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 暴击几率相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_critical_hit_rate: float :
	set(v):
		if player_critical_hit_rate == v:
			return
		player_critical_hit_rate = v
		critical_hit_rate_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 暴击伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_critical_damage: float :
	set(v):
		if player_critical_damage == v:
			return
		player_critical_damage = v
		critical_damage_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 子弹数目相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_number_of_projectiles: int :
	set(v):
		if player_number_of_projectiles == v:
			return
		player_number_of_projectiles = v
		number_of_projectiles_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 子弹速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
var player_projectile_speed: float :
	set(v):
		if player_projectile_speed == v:
			return
		player_projectile_speed = v
		projectile_speed_changed.emit()



func _player_update_parameters() -> void:
	
	'''
	更新武器的属性

	:return: void
	'''
	player_physical_attack_power = owner.base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	player_magic_attack_power = owner.base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	player_attack_speed = owner.base_attack_speed * playerStats.attack_speed_multiplier
	player_rotation_speed = owner.base_rotation_speed * playerStats.attack_speed_multiplier
	player_attack_range = owner.base_attack_range * playerStats.attack_range_multiplier
	player_explosion_range = owner.base_explosion_range * playerStats.attack_range_multiplier
	player_knockback = owner.base_knockback * playerStats.knockback_multiplier
	player_critical_hit_rate = owner.base_critical_hit_rate + playerStats.critical_hit_rate
	player_critical_damage = owner.base_critical_damage + playerStats.critical_damage
	player_number_of_projectiles=owner.base_number_of_projectiles + playerStats.number_of_projectiles
	player_projectile_speed = owner.base_projectile_speed * playerStats.projectile_speed_multiplier


func _on_player_stats_changed() -> void:
	_player_update_parameters()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 羁绊加成 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

 #>>>>>>>>>>>>>>>>>>>>> 物理伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_physical_attack_power: float:
	set(v):
		if trait_physical_attack_power == v:
			return
		trait_physical_attack_power = v
		physical_attack_power_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 魔法伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_magic_attack_power: float:
	set(v):
		if trait_magic_attack_power == v:
			return
		trait_magic_attack_power = v
		physical_attack_power_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 攻击速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_attack_speed: float : 
	set(v):
		if trait_attack_speed == v:
			return
		trait_attack_speed = v
		attack_speed_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 攻击速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_rotation_speed: float : 
	set(v):
		if trait_rotation_speed == v:
			return
		trait_rotation_speed = v
		rotation_speed_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 攻击范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_attack_range: float :
	set(v):
		if trait_attack_range == v:
			return
		trait_attack_range = v
		attack_range_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 爆炸范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_explosion_range: float :
	set(v):
		if trait_explosion_range == v:
			return
		trait_explosion_range = v
		explosion_range_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 击退相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_knockback: float :
	set(v):
		if trait_knockback == v:
			return
		trait_knockback = v
		knockback_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 暴击几率相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_critical_hit_rate: float :
	set(v):
		if trait_critical_hit_rate == v:
			return
		trait_critical_hit_rate = v
		critical_hit_rate_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 暴击伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_critical_damage: float :
	set(v):
		if trait_critical_damage == v:
			return
		trait_critical_damage = v
		critical_damage_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 子弹数目相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_number_of_projectiles: int :
	set(v):
		if trait_number_of_projectiles == v:
			return
		trait_number_of_projectiles = v
		number_of_projectiles_changed.emit()

# >>>>>>>>>>>>>>>>>>>>> 子弹速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
var trait_projectile_speed: float :
	set(v):
		if trait_projectile_speed == v:
			return
		trait_projectile_speed = v
		projectile_speed_changed.emit()
