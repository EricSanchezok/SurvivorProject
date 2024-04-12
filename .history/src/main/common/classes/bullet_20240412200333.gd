class_name Bullet
extends CharacterBody2D


var tracking: bool = false

var penetration_rate: float = 0.0
var attack_speed: float = 100.0
var knockback: float
var damage: float = 0.0


func get_parameters(parent: Node2D) -> void:
    penetration_rate = parent.penetration_rate
    attack_speed = parent.attack_speed
    damage = parent.damage
    

func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
		queue_free()

