extends WeaponBase

var bullet = preload("res://src/main/scene/role/weapons/Staff/Frostbite Touch/frost_magic_bullet.tscn")

func _ready() -> void:
	super()
	print(radius_search)
	rotation = - PI / 2

enum State{
	READY
}

func tick_physics(state: State, delta: float) -> void:
	sync_position()
	if enemies.size() > 0 and $TimerCoolDown.is_stopped():
		target = get_random_enemy()
		$TimerCoolDown.start()
		$AnimationPlayer.play("attack_new")
		
		var dir = target.global_position - position
		scale.y = -1 if dir.x < 0 else 1
		
	match state:
		State.READY:
			pass

func get_next_state(state: State) -> int:
	match state:
		State.READY:
			pass

	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.READY:
			pass


func fire() -> void:
	var instance = bullet.instantiate()
	instance.parent_weapon = self
	instance.tracking = true
	
	instance.rotation = get_random_direction((target.global_position-position).normalized(), 180).angle()
	instance.position = $Graphics/Marker2D.global_position
	get_tree().root.add_child(instance)
