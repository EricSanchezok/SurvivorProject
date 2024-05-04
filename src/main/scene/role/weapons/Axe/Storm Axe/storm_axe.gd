extends WeaponBase

var next_enemies: Array = []
var lightning_chain_scene = preload("res://src/main/scene/role/Special Effect/Lighting Chian/lightning_chain.tscn")

enum State {
	APPEAR,
	WAIT,
	CHARGE,
	ATTACK,
	LANDING,
	DISAPPEAR,
}

var targetPos: Vector2 = Vector2()
var picked_up: bool = false


func _ready() -> void:
	super()
	

func _on_area_pick_up_body_entered(body: Node2D) -> void:
	picked_up = true


func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR:
			sync_slot_position()
			rotation = lerp_angle(rotation, -PI/2, deg_to_rad(weapon_stats.speed_rotation)*delta)
			#sync_direction(-PI/2, deg_to_rad(weapon_stats.speed_rotation)*delta)
			
		State.WAIT:
			sync_slot_position()
		State.CHARGE:
			pass
		State.ATTACK:
			var dir := (targetPos - position).normalized()
			rotation = lerp_angle(rotation, dir.angle(), weapon_stats.speed_rotation)
			#sync_direction(dir.angle(), deg_to_rad(weapon_stats.speed_rotation)*delta)
			position = position.move_toward(targetPos, weapon_stats.speed_fly*delta)
		State.LANDING:
			pass
		State.DISAPPEAR:
			pass

func get_next_state(state: State) -> int:
	match state:
		State.APPEAR:
			if not $AnimationPlayer.is_playing():
				return State.WAIT
		State.WAIT:
			target = get_nearest_enemy(true)
			if target:
				var dir := (target.global_position - position).normalized()
				targetPos = position + dir * weapon_stats.radius_search
				if dir.x < 0:
					scale.y = -1
				else:
					scale.y = +1
				return State.CHARGE
		State.CHARGE:
			if not $AnimationPlayer.is_playing():
				return State.ATTACK
		State.ATTACK:
			if position.distance_to(targetPos) < 0.1:
				return State.LANDING
		State.LANDING:
			if $TimerCoolDown.is_stopped() or picked_up:
				return State.DISAPPEAR
		State.DISAPPEAR:
			if not $AnimationPlayer.is_playing():
				return State.APPEAR
			
	return StateMachine.KEEP_CURRENT
	

func transition_state(from: State, to: State) -> void:
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.APPEAR:
			$Graphics/HitBox.monitoring = false
			$AnimationPlayer.play("appear")
		State.WAIT:
			pass
		State.CHARGE:
			$AnimationPlayer.play("charge")
		State.ATTACK:
			# 归零 scale position rotation
			var total_time = position.distance_to(targetPos) / weapon_stats.speed_fly
			var tween1 = get_tree().create_tween()
			tween1.tween_property($Graphics, "scale", Vector2(1.0, 1.0), total_time)
			var tween2 = get_tree().create_tween()
			tween2.tween_property($Graphics, "position", Vector2.ZERO, 0.15)
			var tween3 = get_tree().create_tween()
			tween3.tween_property($Graphics, "rotation", 0.0, 0.15)
			$Graphics/HitBox.monitoring = true
		State.LANDING:
			$TimerCoolDown.start()
			$AreaPickUp.monitoring = true
			$Graphics/HitBox.monitoring = false
			$AnimationPlayer.play("landing")
		State.DISAPPEAR:
			$AreaPickUp.monitoring = false
			picked_up = false
			$AnimationPlayer.play("disappear")

func trigger_hit_effect() -> void:
	next_enemies = enemies.duplicate()
	var current_target
	var next_target
	var number_of_lighting_chain = weapon_stats.number_of_lighting_chain
	if target:
		next_target = target
	while number_of_lighting_chain > 0:
		current_target = next_target
		next_enemies.erase(current_target)
		next_target = Tools.get_nearest_enemy(weapon_stats.radius_search, next_enemies, global_position)
		if next_target:
			var lighting_chain = lightning_chain_scene.instantiate()
			lighting_chain.parent_weapon = self
			lighting_chain.current_target = current_target
			lighting_chain.next_target = next_target
			get_tree().root.add_child(lighting_chain)
			number_of_lighting_chain -= 1
		else :
			break

