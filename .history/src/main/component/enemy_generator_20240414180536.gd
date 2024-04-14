extends PositionGenerator

@onready var timer: Timer = $Timer



var enemies_to_be_spawned = {}

#func _ready() -> void:
	#print(get_random_position())

func register_enemy(enemy: Node) -> void:
    enemies_to_be_spawned[enemy] = enemy

func _on_timer_timeout() -> void:
	print(get_random_position())
	pass

