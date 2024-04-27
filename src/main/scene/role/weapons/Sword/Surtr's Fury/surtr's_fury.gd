extends WeaponBase

@onready var point_light_2d: PointLight2D = $PointLight2D
var aerolite = preload("res://src/main/scene/role/weapons/Sword/Surtr's Fury/aerolite.tscn")

enum State {
	WAIT,
	ATTACK
}

var current_time: float = 0.0

func _ready() -> void:
	super()

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			rotation = lerp_angle(rotation, -PI/2, deg_to_rad(speed_rotation)*delta)
			position = position.move_toward(slot.global_position, speed_fly*delta*0.5)
		State.ATTACK:
			current_time += delta
			var distance = position.distance_to(target.global_position)
			var total_time = distance / speed_fly
			var t = min(current_time/total_time, 1)
			var start_control_point = position + Vector2(cos(rotation), sin(rotation)) * speed_fly * 0.5
			var next_point = position.bezier_interpolate(start_control_point, target.global_position, target.global_position, t)
			look_at(next_point)
			position = position.move_toward(next_point, speed_fly * delta)
			

func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			target = get_nearest_enemy(true)
			if target and $TimerCoolDown.is_stopped():
				return State.ATTACK
		State.ATTACK:
			if not target or target.is_dead or position.distance_squared_to(target.global_position) < pow(1.0, 2):
				return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	current_time = 0.0
	match to:
		State.WAIT:
			$AnimationPlayer.play("slake")
			$TimerCoolDown.start()
			$HitBox.monitoring = false
		State.ATTACK:
			$AnimationPlayer.play("ignite")
			$HitBox.monitoring = true
			# 召唤陨石
			var instance = aerolite.instantiate()
			instance.target_position = get_random_enemy().global_position
			instance.position = instance.target_position + Vector2(300, -400)
			get_tree().root.add_child(instance)
