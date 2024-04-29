extends Node2D


@onready var enemies = {
	"shade": preload("res://src/main/scene/role/enemy/shade.tscn")
}


func _ready() -> void:
	# var combat_progress = CombatProgressGenerator.create_combat_progress(20, 1, 4)
	 #CombatProgressGenerator.print_combat_progress(combat_progress)
	$EnemyGenerator.register_enemy(enemies["shade"], 10)
	pass
