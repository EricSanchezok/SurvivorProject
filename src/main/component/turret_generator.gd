extends PositionGenerator

var turrets_to_be_spawned = {}

func register_turret(turret, number: int) -> void:
	turrets_to_be_spawned[turret] = number

func _on_timer_timeout() -> void:
	for turret in turrets_to_be_spawned.keys():
		var turret_instance = turret.instantiate()
		turret_instance.position = get_random_position()
		get_tree().root.add_child(turret_instance)
		turrets_to_be_spawned[turret] -= 1
		print(turrets_to_be_spawned[turret])
		if turrets_to_be_spawned[turret] == 0:
			turrets_to_be_spawned.erase(turret)
