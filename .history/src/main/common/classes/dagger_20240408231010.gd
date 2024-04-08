extends Node2D


enum State {
	APPEAR,
	PREPARED,
	RECOVERING,
	HURT,
}



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR:
			pass
		State.PREPARED:
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
			if not animation_player.is_playing():
				return State.PREPARED
		State.PREPARED:
			if health <= 0:
				return State.RECOVERING
		State.RECOVERING:
			if recovery_timer.is_stopped():
				return State.APPEAR
		State.HURT:
			if not animation_player.is_playing():
				return State.PREPARED
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])

	match from:
		State.APPEAR:
			pass
		State.PREPARED:
			pass
		State.RECOVERING:
			health = max_health
		State.HURT:
			pass
	
	match to:
		State.APPEAR:
			animation_player.play("appear")
		State.PREPARED:
			hit_box.monitoring = true
		State.RECOVERING:
			recovery_timer.start()
			hit_box.monitoring = false
			animation_player.play("disappear")
		State.HURT:
			health -= pending_damage.amount
			pending_damage = null
			animation_player.play("hurt")