extends Node2D

@onready var enemy_generator: Area2D = $EnemyGenerator
@onready var turret_generator: Area2D = $turret_generator
var turret = get_node("WeaponsManager")
@onready var enemies = {
	"orc": preload("res://src/main/scene/role/enemy/orc.tscn")
}
@onready var turrets = {
	"turret": preload("res://src/main/scene/role/weapons/Turret/normal_turret.tscn")
}

var number_of_turrets :int = 0

func _ready() -> void:
	var combat_progress = CombatProgressGenerator.create_combat_progress(20, 1, 4)
	# CombatProgressGenerator.print_combat_progress(combat_progress)
	#turret.connect("number_of_turrets",_on_turret_register_turret) 
	turret_generator.register_turret(turrets["turret"], number_of_turrets)
	pass

func _on_timer_timeout() -> void:
	enemy_generator.register_enemy(enemies["orc"], 1)
	pass

func _on_turret_register_turret(number:int) -> void:
	number_of_turrets = number
