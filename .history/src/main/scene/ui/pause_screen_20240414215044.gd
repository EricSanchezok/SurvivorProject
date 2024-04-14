extends Control



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR, State.DIE:
			pass
		State.HURT:
			move_and_slide()
		State.RUN:
			move_to_target()
			pass
			
func get_next_state(state: State) -> int:
	if pending_damage:
		return State.HURT

	if enemyStats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.RUN
		State.RUN:
			pass
		State.HURT:
			if not animation_player.is_playing():
				return State.RUN
		State.DIE:
			pass

				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])
	
	match to:
		State.APPEAR:
			var dir := (target.global_position - global_position).normalized()
			direction = Direction.RIGHT if dir.x > 0 else Direction.LEFT
			animation_player.play("appear")
		State.RUN:
			animation_player.play("run")
		State.HURT:
			enemyStats.health -= pending_damage.amount
			var dir := (pending_damage.source.global_position - global_position).normalized()
			velocity = -dir * pending_damage.knockback
			pending_damage = null
			animation_player.play("hurt")
		State.DIE:
			# 关闭 hurt_box
			hurt_box.monitorable = false
			animation_player.play("death")