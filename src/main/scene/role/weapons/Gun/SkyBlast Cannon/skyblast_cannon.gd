extends WeaponBase

enum State {
	WAIT,
	ATTACK
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			rotation = lerp_angle(rotation, -PI/2, deg_to_rad(speed_rotation)*delta)
			position = position.move_toward(slot.global_position, speed_fly*delta*0.5)
		State.ATTACK:
			pass
			
func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			pass
		State.ATTACK:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.WAIT:
			pass
		State.ATTACK:
			pass
