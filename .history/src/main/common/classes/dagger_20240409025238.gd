extends Node2D

@onready var hit_box: HitBox = $Graphics/HitBox
@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var parentNode: Node2D = get_parent()
@onready var playerStats: Node = parentNode.get_parent().get_parent().get_node("PlayerStats")
@onready var attack_wait_timer: Timer = $AttackWaitTimer

# 基础属性
@export var base_physical_attack_power: float = 0.5
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 50.0
@export var base_attack_speed: float = 100.0
@export var base_attack_distance: float = 15.0
@export var base_rotation_speed: float = 0.8
@export var base_attack_wait_time: float = 0.2
@export var base_knockback: float = 10.0

# 当前属性
var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var attack_speed: float = base_attack_speed
var attack_distance: float = base_attack_distance
var rotation_speed: float = base_rotation_speed
var attack_wait_time: float = base_attack_wait_time
var knockback: float = base_knockback

var enemies: Array = []
var target: CharacterBody2D = null
var appearPos: Vector2 = Vector2()
var targetPos: Vector2 = Vector2()

var damage: float = 0.0
var forward: bool = true
var finished: bool = false


enum State {
	WAIT,
	CALCULATE,
	APPEAR,
	DISAPPEAR,
	ATTACK,
	FORWARD,
	BACKWARD
}

func _ready() -> void:
	'''
	初始化

	:return: void
	'''
	# 监听玩家属性节点的属性变化事件，更新武器的属性
	_update_parameters()
	playerStats.connect("physical_attack_power_multiplier_changed", _on_changed_physical_attack_power_multiplier)
	playerStats.connect("magic_attack_power_multiplier_changed", _on_changed_magic_attack_power_multiplier)
	playerStats.connect("attack_power_multiplier_changed", _on_changed_attack_power_multiplier)
	playerStats.connect("attack_range_multiplier_changed", _on_changed_attack_range_multiplier)
	playerStats.connect("attack_speed_multiplier_changed", _on_changed_attack_speed_multiplier)
	playerStats.connect("knockback_multiplier_changed", _on_changed_knockback_multiplier)


func _update_parameters() -> void:
	'''
	更新武器的属性

	:return: void
	'''
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	attack_speed = base_attack_speed * playerStats.attack_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	attack_distance = base_attack_distance * playerStats.attack_range_multiplier
	knockback = base_knockback * playerStats.knockback_multiplier

	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	attack_wait_timer.wait_time = attack_wait_time

	area_2d.scale = Vector2(attack_range/10.0, attack_range/10.0)

	damage = physical_attack_power + magic_attack_power

func get_nearest_enemy() -> CharacterBody2D:
	'''
	获取最近的敌人

	:return: CharacterBody2D 最近的敌人
	'''
	var nearestEnemy: CharacterBody2D = null
	var nearestDistance: float = attack_range
	for enemy in enemies:
		var distance = area_2d.global_position.distance_to(enemy.global_position)
		if distance < nearestDistance:
			nearestEnemy = enemy
			nearestDistance = distance
	return nearestEnemy
	
func get_random_position() -> Vector2:
	'''
	获取距离圆心固定距离的随机位置

	:return: Vector2 随机位置
	'''
	var radius = attack_distance
	var angle = randf_range(0, 360)
	return Vector2(cos(angle), sin(angle)) * radius

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)

func _on_changed_physical_attack_power_multiplier() -> void:
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	damage = physical_attack_power + magic_attack_power

func _on_changed_magic_attack_power_multiplier() -> void:
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	damage = physical_attack_power + magic_attack_power

func _on_changed_attack_power_multiplier() -> void:
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	damage = physical_attack_power + magic_attack_power

func _on_changed_attack_range_multiplier() -> void:
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	attack_distance = base_attack_distance * playerStats.attack_range_multiplier
	area_2d.scale = Vector2(attack_range/10.0, attack_range/10.0)

func _on_changed_attack_speed_multiplier() -> void:
	attack_speed = base_attack_speed * playerStats.attack_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	attack_wait_timer.wait_time = attack_wait_time

func _on_changed_knockback_multiplier() -> void:
	knockback = base_knockback * playerStats.knockback_multiplier

func move_towards_target(player: CharacterBody2D, target_position: Vector2, delta: float) -> void:
	# 计算目标方向和距离
	var direction_to_target = (target_position - global_position).normalized()
	var distance_to_target = global_position.distance_to(target_position)
	
	# 计算基础移动步长
	var base_movement_step = attack_speed * delta
	
	# 根据父节点的速度调整实际移动步长
	var adjusted_movement_step = calculate_adjusted_movement_step(direction_to_target, base_movement_step, delta)
	
	# 如果距离小于或等于调整后的步长，直接到达目标位置
	if distance_to_target <= adjusted_movement_step.length():
		global_position = target_position
	else:
		global_position += adjusted_movement_step

# 计算考虑父节点速度后的调整移动步长
func calculate_adjusted_movement_step(parentVelocity:Vector2, direction: Vector2, base_step: float, delta: float) -> Vector2:
	if not parentVelocity.is_zero_approx():
		var velocity_relative_to_parent = (direction * attack_speed) - parentVelocity
		return velocity_relative_to_parent * delta
	else:
		return direction * base_step

# func move_towards_custom(target_position: Vector2, delta: float) -> void:
# 	var direction = (target_position - global_position).normalized()  # 计算方向向量
# 	var distance = global_position.distance_to(target_position)  # 计算到目标位置的距离

# 	var movement_step = attack_speed * delta  # 计算步长
	
# 	if distance <= movement_step:
# 		global_position = target_position  # 如果步长大于等于到目标的距离，直接设置为目标位置
# 	else:
# 		var parent_velocity = parentNode.get_parent().get_parent().velocity
# 		if not parent_velocity.is_zero_approx():
# 			var velocity = direction * attack_speed
# 			velocity = velocity - parent_velocity
# 			var real_movement_step = velocity * delta
# 			global_position += real_movement_step
# 		else:
# 			global_position += direction * movement_step  # 否则按步长移动

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			rotation = lerp_angle(rotation, parentNode.rotation, rotation_speed)
		State.CALCULATE:
			pass
		State.APPEAR:
			pass
		State.DISAPPEAR:
			pass
		State.ATTACK:

			
			# var targetDirection := local_pos_for_target_global_pos - global_position
			# rotation = lerp_angle(rotation, targetDirection.angle()-PI/2, rotation_speed)
			
			move_towards_target(targetPos, delta)
			if global_position.distance_to(targetPos) < 0.1:
				finished = true
		State.FORWARD:
			pass
		State.BACKWARD:
			pass
			
func get_next_state(state: State) -> int:
	if not target and state != State.WAIT and state != State.BACKWARD and forward:
		finished = false
		return State.BACKWARD
	match state:
		State.WAIT:
			target = get_nearest_enemy()
			if target and attack_wait_timer.is_stopped():
				finished = false
				return State.FORWARD
		State.CALCULATE:
			if finished:
				finished = false
				return State.ATTACK
		State.APPEAR:
			if not animation_player.is_playing():
				finished = false
				if forward:
					return State.CALCULATE
				else:
					return State.WAIT
		State.DISAPPEAR:
			if not animation_player.is_playing():
				return State.APPEAR
		State.ATTACK:
			if finished:
				finished = false
				return State.CALCULATE
		State.FORWARD:
			if finished:
				finished = false
				return State.DISAPPEAR
		State.BACKWARD:
			if finished:
				finished = false
				return State.DISAPPEAR
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])

	match to:
		State.WAIT:
			hit_box.monitoring = false
			attack_wait_timer.start()
		State.CALCULATE:
			hit_box.monitoring = false
			var dir := target.global_position - global_position
			targetPos = target.global_position + dir.normalized() * attack_distance
			finished = true
		State.APPEAR:
			hit_box.monitoring = false
			animation_player.play("appear")
			global_position = appearPos
		State.DISAPPEAR:
			hit_box.monitoring = false
			animation_player.play("disappear")
		State.ATTACK:
			hit_box.monitoring = true
		State.FORWARD:
			hit_box.monitoring = false
			forward = true
			appearPos = target.global_position + get_random_position()
			finished = true
		State.BACKWARD:
			hit_box.monitoring = false
			forward = false
			appearPos = parentNode.global_position
			finished = true



