extends WeaponBase


@onready var distance_reminder: Sprite2D = $distance_reminder
@onready var base_reminder_scale = distance_reminder.scale



@export var thrust_distance: float = 30
@export var reminder_threshold: float = 0.5
@export var furthest_distance_coefficient: float = 2.0
@export var start_move: bool = false

var random_position: Vector2
var target_direction: Vector2
var back: bool = false


var reset_hitbox: bool = false

enum State{
	WAIT,
	MOVE,
	ATTACK,
}

func tick_physics(state: State, delta: float) -> void:
	var distance_to_player = position.distance_to(player.global_position)
	var ratio = distance_to_player / (weapon_stats.radius_search * furthest_distance_coefficient)
	if ratio > reminder_threshold:
		distance_reminder.visible = true
		distance_reminder.scale = base_reminder_scale + Vector2(ratio-reminder_threshold, ratio-reminder_threshold)
		
	else:
		distance_reminder.visible = false
		
		
	if reset_hitbox:
		reset_hitbox = false
		$Graphics/HitBox.monitoring = true
		return

	match state:
		State.WAIT:
			$Graphics.rotation = lerp_angle($Graphics.rotation, -PI/2, deg_to_rad(weapon_stats.speed_rotation)*delta)
			sync_position()
		State.MOVE:
			if start_move:
				if not back:
					position = target.global_position + random_position
				else:
					sync_position()
			else:
				if not back:
					sync_position()
				else:
					$Graphics.rotation = lerp_angle($Graphics.rotation, -PI/2, deg_to_rad(weapon_stats.speed_rotation)*delta)
					
		State.ATTACK:
			var target_position = target.global_position + target_direction * thrust_distance
			position = position.move_toward(target_position, weapon_stats.speed_fly*delta)
			$Graphics.look_at(target_position)
			if position.distance_squared_to(target_position) <= pow(3, 2):
				target_direction = (target.global_position - position).normalized()
				$Graphics/HitBox.monitoring = false
				reset_hitbox = true
				

func get_next_state(state: State) -> int:
	if position.distance_squared_to(player.global_position) > pow(weapon_stats.radius_search*furthest_distance_coefficient, 2):
		back = true	
		return StateMachine.KEEP_CURRENT if state == State.MOVE else State.MOVE
		
	match state:
		State.WAIT:
			target = get_nearest_enemy(false)
			if target and $TimerCoolDown.is_stopped():
				back = false
				return State.MOVE
		State.MOVE:
			if not $AnimationPlayer.is_playing():
				if not back:
					return State.ATTACK
				else:
					return State.WAIT
		State.ATTACK:
			if not target or target.is_dead:
				back = true	
				return State.MOVE

	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	
	match to:
		State.WAIT:
			start_move = false
			$TimerCoolDown.start()
		State.MOVE:
			if not back:
				random_position = get_random_position_on_circle(thrust_distance)
			$AnimationPlayer.play("move")
		State.ATTACK:
			start_move = false
			$Graphics/HitBox.monitoring = true
			target_direction = (target.global_position - position).normalized()
			
func move_to_position() -> void:
	pass
