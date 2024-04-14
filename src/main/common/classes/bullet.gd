class_name Bullet
extends CharacterBody2D

var tracking: bool = false

var penetration_rate: float # 穿透率 0-1
var projectile_speed: float
var knockback: float
var dir: Vector2
var damage: float
var explosion_range: float

func _physics_process(delta: float) -> void:
	velocity = dir * projectile_speed
	self.look_at(velocity+position)
	move_and_slide()


func get_parameters(parent: Node2D) -> void:
	penetration_rate = parent.penetration_rate
	projectile_speed = parent.projectile_speed
	knockback = parent.knockback
	damage = parent.damage
	explosion_range = parent.explosion_range
	

func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
		queue_free()

func _on_destruction_timer_timeout() -> void:
	'''
	 	计时器超时后销毁子弹
	'''
	queue_free()
