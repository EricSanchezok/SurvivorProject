extends PositionGenerator

@onready var timer: Timer = $Timer

#func _ready() -> void:
	#print(get_random_position())

func _on_timer_timeout() -> void:
	print(get_random_position())
	pass

