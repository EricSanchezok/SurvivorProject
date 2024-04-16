extends Node2D

@onready var enemy_generator: Area2D = $EnemyGenerator

@onready var enemies = {
	"orc": preload("res://src/main/scene/role/enemy/orc.tscn")
}

func _ready() -> void:
	var combat_progress = CombatProgressGenerator.create_combat_progress(20, 1, 4)
	CombatProgressGenerator.print_combat_progress(combat_progress)
	pass

func _on_timer_timeout() -> void:
	pass
