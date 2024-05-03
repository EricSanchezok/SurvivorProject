extends CharacterBody2D

var weapon_stats: WeaponStats
var parent_weapon: WeaponBase
var current_target: EnemyBase
var next_target: EnemyBase

@onready var line_2d: Line2D = $Line2D


func _ready() -> void:
	weapon_stats = parent_weapon.weapon_stats.duplicate()
	weapon_stats.power_lighting_chain = parent_weapon.weapon_stats.power_lighting_chain
	weapon_stats.power_physical = parent_weapon.weapon_stats.power_physical * weapon_stats.power_lighting_chain
	weapon_stats.power_magic = parent_weapon.weapon_stats.power_magic * weapon_stats.power_lighting_chain


func trigger_hit_effect() -> void:
	pass
