extends ProjectileBase

var base_radius: float = 30.0

func _ready() -> void:
	super()
	scale.x = weapon_stats.range_explosion / base_radius
	scale.y = weapon_stats.range_explosion / base_radius
	
	
func _on_reach_target() -> void:
	$AnimationPlayer.play("explode")
	stop_moveing = true
