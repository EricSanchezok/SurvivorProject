extends WeaponBase

var current_health: float = health:
	set(v):
		v = clampf(v, 0, health)
		if health == v:
			return
		health = v
		
var pending_damage: Damage

enum State {
	APPEAR,
	WAIT,
	RECOVERING,
	HURT,
}

func tick_physics(state: State, delta: float) -> void:
	position = slot.global_position
	match state:
		State.APPEAR:
			pass
		State.WAIT:
			pass
		State.RECOVERING:
			pass
		State.HURT:
			pass
			
func get_next_state(state: State) -> int:
	if pending_damage:
		return State.HURT

	match state:
		State.APPEAR:
			pass
		State.WAIT:
			pass
		State.RECOVERING:
			pass
		State.HURT:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	 #print("[%s] %s => %s" % [
	 	#Engine.get_physics_frames()	,
	 	#State.keys()[from] if from != -1 else "<START>",
	 	#State.keys()[to],
	 #])

	match from:
		State.APPEAR:
			pass
		State.WAIT:
			pass
		State.RECOVERING:
			pass
		State.HURT:
			pass
	
	match to:
		State.APPEAR:
			pass
		State.WAIT:
			pass
		State.RECOVERING:
			pass
		State.HURT:
			pass
