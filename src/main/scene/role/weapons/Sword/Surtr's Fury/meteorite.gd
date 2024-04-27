extends ProjectileBase


func _ready() -> void:
	super()


func _on_reach_target() -> void:
	$AnimationPlayer.play("explode")
