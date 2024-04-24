extends WeaponBase

var speed_rotation: float = deg_to_rad(20.0)

enum State {
	WAIT,
	ATTACK,
	BACK
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			rotation = lerp_angle(rotation, PI/2, rotation_speed*delta)
			position = slot.global_position
		State.ATTACK:
			var dir = (target.global_position - position).normalized()
			rotation = lerp_angle(rotation, dir.angle(), rotation_speed*delta*3.0)
			position = position.move_toward(target.global_position, attack_windup_speed*delta)
		State.BACK:
			rotation = lerp_angle(rotation, PI/2, rotation_speed*delta)
			position = position.move_toward(slot.global_position, attack_backswing_speed*delta)

func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
			if target and attack_wait_timer.is_stopped():
				return State.ATTACK
		State.ATTACK:
			if not target or position.distance_squared_to(target.global_position) < pow(1.0, 2):
				return State.BACK
		State.BACK:
			if position.distance_squared_to(slot.global_position) < pow(1.0, 2):
				return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.WAIT:
			attack_wait_timer.start()
		State.ATTACK:
			hit_box.monitoring = true
		State.BACK:
			hit_box.monitoring = false
