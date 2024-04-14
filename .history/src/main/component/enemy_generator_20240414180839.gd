extends PositionGenerator

@onready var timer: Timer = $Timer



var enemies_to_be_spawned = {}

#func _ready() -> void:
	#print(get_random_position())

func register_enemy(enemy: CharacterBody2D, number: int) -> void:
	enemies_to_be_spawned[enemy] = number

func _on_timer_timeout() -> void:
	for enemy in enemies_to_be_spawned.keys():
        var enemy_instance = bullets["normal_arrow"].instantiate()
		enemies_to_be_spawned[enemy] -= 1
		timer.stop()

