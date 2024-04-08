extends Node2D

@onready var hit_box: HitBox = $Graphics/HitBox
@onready var area_2d: Area2D = $Area2D


enum State {
	WAIT,
	CALCULATE,
	FORWARD,
	ATTACK,
	BACKWARD
}



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			pass
		State.CALCULATE:
			pass
		State.FORWARD:
			pass
		State.ATTACK:
			pass
		State.BACKWARD:
			pass
			
func get_next_state(state: State) -> int:

	match state:
		State.WAIT:
			pass
		State.CALCULATE:
			pass
		State.FORWARD:
			pass
		State.ATTACK:
			pass
		State.BACKWARD:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])

	match from:
		State.WAIT:
			pass
		State.CALCULATE:
			hit_box.monitoring = true
		State.FORWARD:
			pass
		State.ATTACK:
			pass
		State.BACKWARD:
			pass

	match to:
		State.WAIT:
			pass
		State.CALCULATE:
			hit_box.monitoring = false
			pass
		State.FORWARD:
			pass
		State.ATTACK:
			pass
		State.BACKWARD:
			pass
