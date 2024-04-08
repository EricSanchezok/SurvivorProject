extends Node2D

@onready var hit_box: HitBox = $Graphics/HitBox
@onready var area_2d: Area2D = $Area2D

# 基础属性
@export var base_physical_attack_power: float = 2.0
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 60.0
@export var base_attack_windup_speed: float = 200.0
@export var base_attack_backswing_speed: float = 100.0
@export var base_rotation_speed: float = 0.1
@export var base_attack_wait_time: float = 0.2
@export var base_knockback: float = 100.0


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
