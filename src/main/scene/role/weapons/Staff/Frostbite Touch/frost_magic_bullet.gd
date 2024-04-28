extends ProjectileBase

var base_radius: float = 30.0

func _ready() -> void:
	super()
	$AnimationPlayer.play("idle")
	scale.x = range_explosion / base_radius
	scale.y = range_explosion / base_radius
	
	
func _on_reach_target() -> void:
	$AnimationPlayer.play("explode")
	stop_moveing = true
