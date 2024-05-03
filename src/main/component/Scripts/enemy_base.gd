class_name EnemyBase
extends CharacterBody2D

@onready var enemy_stats: EnemyStats = $EnemyStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var freezing_timer: Timer = $FreezingTimer
@onready var freezing_cooldown_timer: Timer = $FreezingCooldownTimer

const DAMAGE_NUMBERS = preload("res://src/main/scene/ui/damage_number.tscn")

enum Direction {
	LEFT = -1,
	RIGHT = +1,
}

var pending_damages: Array
var target: CharacterBody2D
var random := RandomNumberGenerator.new()
var is_dead: bool = false

@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await  ready
		$Graphics.scale.x = direction
		
enum Effect {
	BURN,
	SLOW,
	POISION,
	FREEZE,
}
var effects_collection: Array
var effects_states: Array[bool]
class effect:
	var value: float = 0.0
	var duration: float = 0.0

var poison_timer = 0.0  # 追踪中毒效果的时间


func _ready() -> void:
	random.randomize()
	for i in range(Effect.size()):
		effects_collection.append([])
		effects_states.append(false)
	target = get_random_target()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	APPEAR,
	RUN,
	DIE,
	HURT,
}


func tick_physics(state: State, delta: float) -> void:
	if is_dead:
		return
	
	# >>>>>>>>>>>>>>>>>>>> 更新效果持续时间 >>>>>>>>>>>>>>>>>>>>
	for type_index in range(effects_collection.size()):
		for _effect in effects_collection[type_index]:
			_effect.duration -= delta
			if _effect.duration <= 0: 
				# 当该效果退出时
				match type_index:
					Effect.BURN:
						pass
					Effect.SLOW:
						pass
					Effect.POISION:
						pass
					Effect.FREEZE:
						$AnimationPlayer.play()
						modulate = Color(1.0, 1.0, 1.0, 1.0)
				effects_collection[type_index].erase(_effect)
	
	# >>>>>>>>>>>>>>>>>>>> 更新效果状态表 >>>>>>>>>>>>>>>>>>>>
	for type_index in range(effects_collection.size()):
		effects_states[type_index] = true if effects_collection[type_index].size() > 0 else false
		# print("type_index: ", type_index, " ", effects_collection[type_index].size())
	
	# >>>>>>>>>>>>>>>>>>>> 结算攻击伤害 >>>>>>>>>>>>>>>>>>>>
	for damage in pending_damages:
		enemy_stats.current_health -= damage.phy_amount + damage.mag_amount
		velocity -= damage.direction * damage.knockback
		create_damage_numbers(damage)
		pending_damages.erase(damage)
		
	# >>>>>>>>>>>>>>>>>>>> 结算效果 >>>>>>>>>>>>>>>>>>>>
	for type_index in range(effects_collection.size()):
		match type_index:
			Effect.BURN:
				if not effects_states[Effect.BURN]: # 未产生效果
					continue
				# 产生效果
				pass
			Effect.SLOW:
				if not effects_states[Effect.SLOW]: # 未产生效果
					enemy_stats.speed_movement = enemy_stats.base_speed_movement
					continue
				# 产生效果
				var max_deceleration_rate = effects_collection[type_index][0].value
				enemy_stats.speed_movement = enemy_stats.base_speed_movement * (1 - max_deceleration_rate)
			Effect.POISION:
				if not effects_states[Effect.POISION]: # 未产生效果
					continue
				# 产生效果
				else :
					poison_timer += delta
					if poison_timer >= 1.0:  # 每秒应用一次中毒伤害
						enemy_stats.health -= effects_collection[type_index][0].value
						poison_timer = 0  # 重置计时器
			Effect.FREEZE:
				if not effects_states[Effect.FREEZE]: # 未产生效果
					continue
				# 产生效果
				velocity *= effects_collection[type_index][0].value
				move_and_collide(velocity*delta)
				return
				
	# >>>>>>>>>>>>>>>>>>>> 敌人状态机 >>>>>>>>>>>>>>>>>>>>
	match state:
		State.APPEAR, State.DIE:
			pass
		State.HURT:
			pass
		State.RUN:
			calculate_velocity_to_target()

	move_and_collide(velocity*delta)

func get_next_state(state: State) -> int:
	if effects_states[Effect.FREEZE]:
		return StateMachine.KEEP_CURRENT
		
	if enemy_stats.current_health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	
	if pending_damages.size() > 0:
		return StateMachine.KEEP_CURRENT if state == State.HURT else State.HURT

	
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.RUN
		State.RUN:
			pass
		State.HURT:
			if not animation_player.is_playing():
				if freezing_timer.is_stopped():
					return State.RUN
		State.DIE:
			pass

				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.APPEAR:
			var dir := (target.global_position - position).normalized()
			direction = Direction.RIGHT if dir.x > 0 else Direction.LEFT
			animation_player.play("appear")
		State.RUN:
			animation_player.play("run")
		State.HURT:
			animation_player.play("hurt")
		State.DIE:
			is_dead = true
			animation_player.play("die")
		
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 功能函数 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func get_random_target() -> PlayerBase:
	'''
		获取随机玩家对象
	
	return: 随机玩家对象
	'''
	var players := get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return null
	return players[random.randi_range(0, players.size() - 1)]

func calculate_velocity_to_target() -> void:
	'''
		移动到目标
	
	param target: 目标
	param delta: 时间间隔
	'''
	if target == null:
		return
	var target_position := target.global_position
	var pos := global_position
	var dir := (target_position - pos).normalized()
	velocity = dir * enemy_stats.speed_movement
	direction = Direction.LEFT if dir.x < 0 else Direction.RIGHT
	
func die() -> void:
	'''
		死亡
	'''
	await not animation_player.is_playing()
	queue_free()

func _on_hurt_box_hurt(hitbox: Variant) -> void:
	create_damage(hitbox)
	create_effets(hitbox)
	
	
func create_damage(hitbox: HitBox) -> void:
	var damage = Damage.new()
	var source_weapon: CharacterBody2D = hitbox.owner
	#print(source_weapon.weapon_stats.power_physical)
	damage.source = source_weapon
	damage.direction = (source_weapon.global_position - position).normalized()
	
	damage.is_critical = Tools.is_success(source_weapon.weapon_stats.critical_hit_rate)
	
	damage.phy_amount = source_weapon.weapon_stats.power_physical if not damage.is_critical else source_weapon.weapon_stats.power_physical * source_weapon.weapon_stats.critical_damage
	damage.mag_amount = source_weapon.weapon_stats.power_magic if not damage.is_critical else source_weapon.weapon_stats.power_magic * source_weapon.weapon_stats.critical_damage
	damage.knockback = source_weapon.weapon_stats.knockback * (1 - enemy_stats.knockback_resistance)
	
	pending_damages.append(damage)
	
func create_effets(hitbox: HitBox) -> void:
	var source_weapon: CharacterBody2D = hitbox.owner
	# 处理减速
	var deceleration_rate = source_weapon.weapon_stats.deceleration_rate * (1 - enemy_stats.deceleration_resistance)
	if deceleration_rate != 0.0:
		var _effect = effect.new()
		_effect.value = deceleration_rate
		_effect.duration = source_weapon.weapon_stats.deceleration_time * (1 - enemy_stats.deceleration_resistance)
		effects_collection[Effect.SLOW].append(_effect)
		effects_collection[Effect.SLOW].sort_custom(compare_slow_effects)
	# 处理冻结
	var is_freeze = false if not freezing_cooldown_timer.is_stopped() else Tools.is_success(source_weapon.weapon_stats.freezing_rate)
	if is_freeze:
		var _effect = effect.new()
		_effect.value = 0.95
		_effect.duration = 2.0 * (1 - enemy_stats.freezing_resistance)
		effects_collection[Effect.FREEZE].append(_effect)
		$AnimationPlayer.pause()
		freezing_cooldown_timer.start()
		modulate = Color.hex(0x49ffff)
	#处理中毒
	var new_poison_layers = source_weapon.weapon_stats.poison_layers
	var max_poison_layers = source_weapon.weapon_stats.max_poison_layers
	if new_poison_layers > 0:
		if not effects_states[Effect.POISION]:
			var _effect = effect.new()
			_effect.value = new_poison_layers
			_effect.duration = 5
			effects_collection[Effect.POISION].append(_effect)
		else :
			effects_collection[Effect.POISION][0].value = min(effects_collection[Effect.POISION][0].value + new_poison_layers, max_poison_layers)

func create_damage_numbers(current_damage: Damage) -> void:
	if current_damage.phy_amount != 0:
		var damage_number = DAMAGE_NUMBERS.instantiate()
		damage_number.position = $Graphics/DamageNumberMarker2D.global_position
		damage_number.velocity = Vector2(randf_range(-50, 50), randf_range(-150, -120))
		damage_number.gravity = Vector2(0, 2.0)
		damage_number.mass = 200
		damage_number.text = current_damage.phy_amount
		damage_number.type = "phy"
		damage_number.is_critical = current_damage.is_critical
		get_tree().root.add_child(damage_number)
	if current_damage.mag_amount != 0:
		var damage_number = DAMAGE_NUMBERS.instantiate()
		damage_number.position = $Graphics/DamageNumberMarker2D.global_position
		damage_number.velocity = Vector2(randf_range(-50, 50), randf_range(-150, -120))
		damage_number.gravity = Vector2(0, 2.0)
		damage_number.mass = 200
		damage_number.text = current_damage.mag_amount
		damage_number.type = "mag"
		damage_number.is_critical = current_damage.is_critical
		get_tree().root.add_child(damage_number)
		
	
	
func compare_slow_effects(a, b):
	if a.value > b.value:
		return true
	else:
		return false

func trigger_hit_effect() -> void:
	pass
