extends Node2D

@onready var enemy_generator: Area2D = $EnemyGenerator

@onready var enemies = {
	"orc": preload("res://src/main/scene/role/enemy/orc.tscn")
}

func _ready() -> void:
	var map = CombatProgressGenerator.create_game_map(10, 1, 4)
	CombatProgressGenerator.print_map(map)


func _on_timer_timeout() -> void:
	enemy_generator.register_enemy(enemies["orc"], 1)
	pass
