extends WeaponBase

var bullet = preload("res://src/main/scene/role/weapons/Firearm/Doombringer/destruction_shell.tscn")

func _ready() -> void:
	super()

enum State {
	WAIT,
	ATTACK
}

var fire_count: int = 0

func tick_physics(state: State, delta: float) -> void:
	parent_update()
	sync_slot_position()
	match state:
		State.WAIT:
			pass
		State.ATTACK:
			pass
			
func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			target = get_random_enemy()
			if target and $TimerCoolDown.is_stopped():
				return State.ATTACK
		State.ATTACK:
			if not $AnimationPlayer.is_playing():
				if fire_count < weapon_stats.magazine:
					return State.ATTACK
				else:
					return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.WAIT:
			fire_count = 0
		State.ATTACK:
			$AnimationPlayer.play("attack")
			
			
func find_and_fire() -> void:
	target = get_random_enemy()
	if target:
		$TimerCoolDown.start()
		var instance = bullet.instantiate()
		instance.parent_weapon = self
		
		instance.initial_rotation = get_random_direction(Vector2(0, -1), 30).angle()
		instance.position = $Graphics/Marker2D.global_position
		get_tree().root.add_child(instance)
	fire_count += 1
