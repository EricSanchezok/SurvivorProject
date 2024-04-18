extends Node2D


var start_flag: bool = false
var current_level_index: int = 0
var current_route: Array
var current_combat_progress: Array


func _ready() -> void:
	CombatProgressGenerator.connect("update_combat_progress", _on_update_combat_progress)
	CombatRouteManager.connect("update_current_route", _on_update_current_route)


func have_route(current_level_index) -> bool:
	return current_route.size() - current_level_index > 1
	
func _on_update_combat_progress(nodes: Array) -> void:
	start_flag = true
	current_combat_progress = CombatRouteManager.current_combat_progress
	current_route = CombatRouteManager.current_route
	
func _on_update_current_route() -> void:
	current_route = CombatRouteManager.current_route

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	IDLE,
	CHOOSE_ROUTE,
	WAIT_TO_CHOOSE,
	CHOOSE_ROUTE_LEAVE,
	ENTER,
	SHOP,
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.IDLE:
			pass
		State.CHOOSE_ROUTE:
			pass
		State.WAIT_TO_CHOOSE:
			pass
		State.CHOOSE_ROUTE_LEAVE:
			pass
		State.ENTER:
			pass
		State.SHOP:
			pass

func get_next_state(state: State) -> int:
	match state:
		State.IDLE:
			if start_flag:
				return StateMachine.KEEP_CURRENT if state == State.CHOOSE_ROUTE else State.CHOOSE_ROUTE
		State.CHOOSE_ROUTE:
			if have_route(current_level_index):
				return State.ENTER
			else:
				return State.WAIT_TO_CHOOSE
		State.WAIT_TO_CHOOSE:
			if have_route(current_level_index):
				if Game.next_level:
					return State.CHOOSE_ROUTE_LEAVE
			else:
				Game.next_level = false
		State.CHOOSE_ROUTE_LEAVE:
			if not Game.pause_animation_player.is_playing():
				return State.ENTER
		State.ENTER:
			pass
		State.SHOP:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:
	print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.IDLE:
			pass
		State.CHOOSE_ROUTE:
			Game.pause_animation_player.play("OnlyCombatProgressAppear")
		State.WAIT_TO_CHOOSE:
			pass
		State.CHOOSE_ROUTE_LEAVE:
			Game.next_level = false
			Game.pause_animation_player.play("OnlyCombatProgressDisappear")
		State.ENTER:
			current_level_index += 1
		State.SHOP:
			pass






