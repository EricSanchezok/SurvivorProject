extends PositionGenerator

@onready var timer: Timer = $Timer



var enemies_to_be_spawned = {}

#func _ready() -> void:
	#print(get_random_position())

func register_enemy(enemy: CharacterBody2D, number: int) -> void:
	enemies_to_be_spawned[enemy] = number

func _on_timer_timeout() -> void:
	for enemy in enemies_to_be_spawned.keys():
        var enemy_instance = enemy.instantiate()
        enemy_instance.position = get_random_position()
        get_tree().get_root().add_child(enemy_instance)
		enemies_to_be_spawned[enemy] -= 1
		timer.stop()

