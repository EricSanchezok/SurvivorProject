extends PositionGenerator

@onready var timer: Timer = $Timer



var Enemies to be spawned

#func _ready() -> void:
	#print(get_random_position())

func _on_timer_timeout() -> void:
	print(get_random_position())
	pass

