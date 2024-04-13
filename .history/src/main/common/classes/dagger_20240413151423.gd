class_name Dagger
extends Node2D

# 节点引用
@onready var hit_box: HitBox = $Graphics/HitBox
@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var parentNode: Node2D = get_parent()
@onready var player: CharacterBody2D = get_parent().get_parent().get_parent()
@onready var playerStats: Node = player.get_node("PlayerStats")
@onready var attack_wait_timer: Timer = $AttackWaitTimer

# 基础属性
@export var base_physical_attack_power: float = 0.5
@export var base_magic_attack_power: float = 0.0
@export var base_furthest_distance: float = 100.0 # 离开玩家的最远距离
@export var base_attack_range: float = 50.0 # 自动索敌的范围
@export var base_attack_speed: float = 100.0
@export var base_attack_distance: float = 15.0 # 在敌人附近来回攻击的距离
@export var base_rotation_speed: float = 15.0 # 转向速度
@export var base_attack_wait_time: float = 0.8
@export var base_knockback: float = 10.0

# 当前属性
var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var furthest_distance: float = base_furthest_distance
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

var non_transferable_states = [State.WAIT]

func _ready() -> void:
	'''
	初始化

	:return: void
	'''
	# 监听玩家属性节点的属性变化事件，更新武器的属性
	_update_parameters()
	playerStats.connect("stats_changed", _on_stats_changed)

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


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	if target:
		# print("position:", position)
		# print("global_position:", global_position)
		# print("position:", target.position)
		# print("global_position:", target.global_position)
		# print("position:", to_local(target.global_position))
		# print("global_position:", target.global_position)
		pass
	match state:
		State.WAIT:
			rotation = lerp_angle(rotation, PI/2, rotation_speed*delta)
			# self.look_at(global_position+Vector2.DOWN)
			# rotation = lerp_angle(rotation, parentNode.rotation, rotation_speed*delta)
		State.CALCULATE:
			pass
		State.APPEAR:
			if forward:
				global_position = appearPos
			else:
				global_position = parentNode.global_position
		State.DISAPPEAR:
			pass
		State.ATTACK:
			var dir := (targetPos - global_position).normalized()
			rotation = lerp_angle(rotation, dir.angle(), rotation_speed*delta)
			# var targetDirection := targetPos - global_position
			# rotation = lerp_angle(rotation, targetDirection.angle()-PI/2, rotation_speed*delta)
			# position = position.move_toward(to_local(target.global_position), attack_speed*delta)
			# global_position = Tools.move_towards_target(player, attack_speed, global_position, targetPos, delta)
			if global_position.distance_to(targetPos) < 0.1:
				finished = true
		State.FORWARD:
			pass
		State.BACKWARD:
			pass

func beyond_distance() -> bool:
	return global_position.distance_to(player.global_position) > furthest_distance


func get_next_state(state: State) -> int:
	if (not target or beyond_distance()) and state not in non_transferable_states and forward:
		finished = false
		return StateMachine.KEEP_CURRENT if state == State.BACKWARD else State.BACKWARD
	match state:
		State.WAIT:
			target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
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
	print("[%s] %s => %s" % [
		Engine.get_physics_frames()	,
		State.keys()[from] if from != -1 else "<START>",
		State.keys()[to],
	])

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
			finished = true

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 参数更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _update_parameters() -> void:
	'''
	更新武器的属性

	:return: void
	'''
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	furthest_distance = base_furthest_distance * playerStats.attack_range_multiplier
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	attack_speed = base_attack_speed * playerStats.attack_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	attack_distance = base_attack_distance * playerStats.attack_range_multiplier
	knockback = base_knockback * playerStats.knockback_multiplier

	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	attack_wait_timer.wait_time = attack_wait_time

	area_2d.scale = Vector2(attack_range/10.0, attack_range/10.0)

	damage = physical_attack_power + magic_attack_power
	
func _on_stats_changed() -> void:
	_update_parameters()
