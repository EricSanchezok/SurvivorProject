extends Node2D

@onready var state_machine: StateMachine = $StateMachine

@export var base_max_health: float = 20.0
@export var base_health_regeneration: float = 1.0
@export var base_recovery_time: float = 5.0

@export var base_physical_attack_power: float = 3.0
@export var base_magic_attack_power: float = 0.0

var damage: float = 0.0

enum State {
	PREPARED,
	RECOVERING
}

func _update_parameters()





# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.PREPARED:
			pass
		State.RECOVERING:
			pass
			
func get_next_state(state: State) -> int:
	if enemy_stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.RUN
		State.RUN:
			pass
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
		State.DIE:
			# 关闭 hurt_box
			hurt_box.monitorable = false
			die()