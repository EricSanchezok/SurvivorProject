class_name Bullet
extends CharacterBody2D


var automatic_tracking: bool = false

var penetration_rate: float = 0.0
var base_physical_attack_power: float = 1.0
var base_magic_attack_power: float = 0.0

func _on_hit_box_hit(hurtbox: Variant) -> void:
	# 根据穿透率，判断是否消失
    
