extends Node2D

@onready var enemy_generator: Area2D = $EnemyGenerator

@onready var enemies = {
	"orc": preload("res://src/main/scene/role/enemy/orc.tscn")
}

func _ready() -> void:
	
	#CombatProgressGenerator.print_map(map)
	pass

func _on_timer_timeout() -> void:
	var map = CombatProgressGenerator.create_game_map(10, 1, 4)
	# enemy_generator.register_enemy(enemies["orc"], 20)
	pass
