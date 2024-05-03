extends WeaponBase

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

var current_health: float:
	set(v):
		v = clampf(v, 0, weapon_stats.health)
		if current_health == v:
			return
		current_health = v
		texture_progress_bar.value = current_health / weapon_stats.health
		
		
var pending_damages: Array

func _ready() -> void:
	super()
	sync_direction(-PI/2)
	current_health = weapon_stats.health

enum State {
	APPEAR,
	WAIT,
	RECOVERING,
	HURT,
}

func tick_physics(state: State, delta: float) -> void:
	parent_update()
	# 同步父节点位置
	sync_slot_position()
	
	for damage in pending_damages:
		current_health -= damage.amount
		pending_damages.erase(damage)
		
	match state:
		State.APPEAR:
			pass
		State.WAIT:
			# 恢复生命值
			if current_health > 0.0:
				current_health = current_health + weapon_stats.health_regeneration * delta
		State.RECOVERING:
			pass
		State.HURT:
			# 恢复生命值
			if current_health > 0.0:
				current_health = current_health + weapon_stats.health_regeneration * delta
			
func get_next_state(state: State) -> int:
	if pending_damages.size() > 0 and state != State.RECOVERING:
		return StateMachine.KEEP_CURRENT if state == State.HURT else State.HURT

	match state:
		State.APPEAR:
			if not $AnimationPlayer.is_playing():
				return State.WAIT
		State.WAIT:
			if current_health <= 0:
				return State.RECOVERING
		State.RECOVERING:
			if $TimerCoolDown.is_stopped():
				return State.APPEAR
		State.HURT:
			if not $AnimationPlayer.is_playing():
				return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.APPEAR:
			$AnimationPlayer.play("appear")
			hurt_box.monitorable = false
		State.WAIT:
			hurt_box.monitorable = true
		State.RECOVERING:
			$AnimationPlayer.play("recovering")
			$TimerCoolDown.start()
			current_health = weapon_stats.health
			hurt_box.monitorable = false
		State.HURT:
			$AnimationPlayer.play("hurt")
			hurt_box.monitorable = false




func _on_hurt_box_hurt(hitbox: Variant) -> void:
	var damage = Damage.new()
	var enemy = hitbox.owner
	damage.source = enemy
	damage.amount = enemy.enemy_stats.damage
	pending_damages.append(damage)


func _on_weapon_stats_update_attribute() -> void:
	scale = Vector2(weapon_stats.range_attack, weapon_stats.range_attack)
