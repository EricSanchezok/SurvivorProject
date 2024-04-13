class_name Bullet
extends CharacterBody2D

var tracking: bool = false

var penetration_rate: float # 穿透率 0-1
var attack_speed: float
var knockback: float
var dir: Vector2
var damage: float

func _physics_process(delta: float) -> void:
	velocity = dir * attack_speed
	self.look_at(velocity+position)
	move_and_slide()


func get_parameters(parent: Node2D) -> void:
	penetration_rate = parent.penetration_rate
	attack_speed = parent.attack_speed
	knockback = parent.knockback
	damage = parent.damage
	

func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
		queue_free()

func _on_destruction_timer_timeout() -> void:
	'''
	 	计时器超时后销毁子弹
	'''
	queue_free()
