class_name Bullet
extends CharacterBody2D


var automatic_tracking: bool = false

var penetration_rate: float = 0.0
var attack_speed: float = 100.0
var damage: float = 0.0


func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
		queue_free()

