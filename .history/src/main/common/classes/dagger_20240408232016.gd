extends Node2D


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