class_name Bullet
extends CharacterBody2D


var automatic_tracking: bool = false

var penetration_rate: float = 0.0
var base_physical_attack_power: float = 1.0
var base_magic_attack_power: float = 0.0


func finish():
    queue_free()

func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
        finish()

