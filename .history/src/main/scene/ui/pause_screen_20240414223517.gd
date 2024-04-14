extends Control


var viewport = get_viewport()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	IDLE,
	INVENTORY,
	COMBAT_PROGRESS,
	EQUIPMENT,
	QUESTS,
	SAVE_LOAD,
	SETTINGS
}


func tick_physics(state: State, delta: float) -> void:
    # 打印视口中心
    # print(viewport.get_camera_position())

	match state:
		State.IDLE:
			pass
		State.INVENTORY:
			pass
		State.COMBAT_PROGRESS:
			pass
		State.EQUIPMENT:
			pass
		State.QUESTS:
			pass
		State.SAVE_LOAD:
			pass
		State.SETTINGS:
			pass
			
func get_next_state(state: State) -> int:
	match state:
		State.IDLE:
			pass
		State.INVENTORY:
			pass
		State.COMBAT_PROGRESS:
			pass
		State.EQUIPMENT:
			pass
		State.QUESTS:
			pass
		State.SAVE_LOAD:
			pass
		State.SETTINGS:
			pass

	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])
	
	match to:
		State.IDLE:
			pass
		State.INVENTORY:
			pass
		State.COMBAT_PROGRESS:
			pass
		State.EQUIPMENT:
			pass
		State.QUESTS:
			pass
		State.SAVE_LOAD:
			pass
		State.SETTINGS:
			pass
