extends WeaponBase

var speed_rotation: float = deg_to_rad(360.0)
var speed_projectile: float = 300.0

var damage: float = 2.0
var knockback: float = 50.0

var aerolite = preload("res://src/main/scene/role/weapons/Sword/Surtr's Fury/aerolite.tscn")

enum State {
	WAIT,
	ATTACK
}

var target: CharacterBody2D 

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			rotation = lerp_angle(rotation, PI/2, speed_rotation*delta)
			position = position.move_toward(slot.global_position, speed_projectile*delta*0.5)
		State.ATTACK:
			var dir = (target.global_position - position).normalized()
			rotation = lerp_angle(rotation, dir.angle(), speed_rotation*delta*3.0)
			position = position.move_toward(target.global_position, speed_projectile*delta)


func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			target = get_nearest_enemy()
			if target and $TimerCoolDown.is_stopped():
				return State.ATTACK
		State.ATTACK:
			if not target or target.is_dead or position.distance_squared_to(target.global_position) < pow(1.0, 2):
				return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.WAIT:
			$TimerCoolDown.start()
			$HitBox.monitoring = false
		State.ATTACK:
			$HitBox.monitoring = true
			var instance = aerolite.instantiate()
			instance.target_position = get_random_enemy().global_position
			instance.position = instance.target_position + Vector2(300, -500)
			get_tree().root.add_child(instance)
