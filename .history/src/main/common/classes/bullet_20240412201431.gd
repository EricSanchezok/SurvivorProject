class_name Bullet
extends CharacterBody2D


var tracking: bool = false

var penetration_rate: float # 穿透率 0-1
var attack_speed: float
var knockback: float
var damage: float


func get_parameters(parent: Node2D) -> void:
	penetration_rate = parent.penetration_rate
	attack_speed = parent.attack_speed
	knockback = parent.knockback
	damage = parent.damage
	

func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
		queue_free()

