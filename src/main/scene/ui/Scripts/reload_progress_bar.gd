extends Marker2D

@onready var progress: Sprite2D = $Progress
var start: bool = false

@export var value: float = 1.0:
	set(v):
		value = clampf(v, 0.0, 1.0)
		if not start:
			return
		progress.position.x = lerpf(-12, 12, value)
		$Timer.start()
		if modulate.a == 0.0:
			$AnimationPlayer.play("show")



func _on_timer_timeout() -> void:
	$AnimationPlayer.play("fade")


func _on_ready() -> void:
	start = true
