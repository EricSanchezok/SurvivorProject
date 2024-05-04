extends WeaponBase

@onready var hit_box_timer: Timer = $HitBoxTimer
@onready var gpu_particles_2d: GPUParticles2D = $Graphics/GPUParticles2D
@onready var base_particles_amount = gpu_particles_2d.amount
@onready var base_scale_min = gpu_particles_2d.process_material.scale_min
@onready var base_scale_max = gpu_particles_2d.process_material.scale_max


enum State{
	WAIT,
	ATTACK
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			pass
		State.ATTACK:
			towards_target(target.global_position, deg_to_rad(weapon_stats.speed_rotation*delta), true)

func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			target = get_nearest_enemy(true)
			if target:
				return State.ATTACK
		State.ATTACK:
			if not target or target not in enemies or target.is_dead:
				return State.WAIT

	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.WAIT:
			hit_box_timer.stop()
			gpu_particles_2d.emitting = false
		State.ATTACK:
			hit_box_timer.start()
			gpu_particles_2d.emitting = true


func _on_hit_box_timer_timeout() -> void:
	hit_box.monitoring = false if hit_box.monitoring else true


func _on_weapon_stats_update_attribute() -> void:
	var ratio = weapon_stats.range_attack
	scale = Vector2(ratio, ratio)
	# 该武器搜索范围和攻击范围属于绑定
	weapon_stats.radius_search = weapon_stats.base_radius_search * ratio
	gpu_particles_2d.amount = base_particles_amount * ratio
	gpu_particles_2d.process_material.scale_min = base_scale_min * ratio
	gpu_particles_2d.process_material.scale_max = base_scale_max * ratio
