extends WeaponBase

var bullet = preload("res://src/main/scene/role/weapons/Staff/Frostbite Touch/frost_magic_bullet.tscn")

enum State{
	READY
}

func tick_physics(state: State, delta: float) -> void:
	position = slot.global_position
	rotation = lerp_angle(rotation, -PI/2, deg_to_rad(speed_rotation)*delta)
	if enemies.size() > 0 and $TimerCoolDown.is_stopped():
		target = get_random_enemy()
		fire(target)
		$TimerCoolDown.start()
		
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


func fire(enemy: EnemyBase) -> void:
	var instance = bullet.instantiate()
	instance.parent_weapon = self
	instance.tracking = true
	instance.bezier = true
	
	instance.rotation = get_random_direction((enemy.global_position-position).normalized(), 270).angle()
	instance.position = $Marker2D.global_position
	get_tree().root.add_child(instance)
