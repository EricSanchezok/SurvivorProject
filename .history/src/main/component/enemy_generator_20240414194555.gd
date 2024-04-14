extends PositionGenerator


var enemies_to_be_spawned = {}

#func _ready() -> void:
	#print(get_random_position())

func register_enemy(enemy, number: int) -> void:
	enemies_to_be_spawned[enemy] = number

func _on_timer_timeout() -> void:
	
	for enemy in enemies_to_be_spawned.keys():
		var enemy_instance = enemy.instantiate()
		enemy_instance.position = get_random_position()
		get_tree().root.add_child(enemy_instance)
		enemies_to_be_spawned[enemy] -= 1
		print(enemies_to_be_spawned[enemy])
		if enemies_to_be_spawned[enemy] == 0:
			enemies_to_be_spawned.erase(enemy)

