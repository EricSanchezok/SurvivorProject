extends WeaponBase

enum State {
	WAIT,
	ATTACK
}

var current_time: float = 0.0
var thresholds: Array = [5,10,20,50,100]
var nature_kills: int = 0:
	set(v):
		player.nature_trait.nature_kills += 1
		nature_kills = v


func _ready() -> void:
	super()

func tick_physics(state: State, delta: float) -> void:
	parent_update()
	match state:
		State.WAIT:
			sync_direction(-PI/2, deg_to_rad(weapon_stats.speed_rotation)*delta)
			# rotation = lerp_angle(rotation, -PI/2, deg_to_rad(weapon_stats.speed_rotation)*delta)
			sync_slot_position(weapon_stats.speed_fly*delta*0.5)
		State.ATTACK:
			current_time += delta
			var distance = position.distance_to(target.global_position)
			var total_time = distance / weapon_stats.speed_fly
			var t = min(current_time/total_time, 1)
			var start_control_point = position + Vector2(cos(rotation), sin(rotation)) * weapon_stats.speed_fly * 1.5
			var next_point = position.bezier_interpolate(start_control_point, target.global_position, target.global_position, t)
			towards_target(next_point)
			# look_at(next_point)
			position = position.move_toward(next_point, weapon_stats.speed_fly * delta)
			

func get_next_state(state: State) -> int:
	if state != State.WAIT:
		if not target:
			return State.WAIT
		if target.is_dead:
			return State.WAIT
	match state:
		State.WAIT:
			target = get_nearest_enemy(true)
			if target and $TimerCoolDown.is_stopped():
				return State.ATTACK
		State.ATTACK:
			if not target or target.is_dead or position.distance_squared_to(target.global_position) < pow(5.0, 2):
				return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	current_time = 0.0
	match to:
		State.WAIT:
			$AnimationPlayer.play("slake")
			$TimerCoolDown.start()
			$Graphics/HitBox.monitoring = false
		State.ATTACK:
			$AnimationPlayer.play("ignite")
			$Graphics/HitBox.monitoring = true

func set_kills(value: int,kills: int) -> void:
	if weapon_stats.is_grow_naturally == 1:
		nature_kills += 1


