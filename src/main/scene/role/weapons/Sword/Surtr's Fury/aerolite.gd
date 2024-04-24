extends CharacterBody2D

var damage: float = 15.0
var knockback: float = 120.0

var target_position: Vector2
var acceleration: float = 100.0
var max_speed: float = 300.0



func _physics_process(delta: float) -> void:
	if position.distance_squared_to(target_position) < pow(1, 2):
		$AnimationPlayer.play("explode")
		
	position = position.move_toward(target_position, max_speed*delta)
	$Graphics.look_at(target_position)
	
	#var dir := (target_position - position).normalized()
	#velocity.x = lerpf(velocity.x, max_speed, acceleration*delta)
	#velocity.y = lerpf(velocity.y, max_speed, acceleration*delta)
	#move_and_slide()
	

func free() -> void:
	queue_free()
	
