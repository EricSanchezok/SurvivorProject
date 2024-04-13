class_name Axe
extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 武器基类 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var slot: Node2D
var player: CharacterBody2D
var playerStats: Node

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var hit_box = $Graphics/HitBox
@onready var area_2d = $Area2D
@onready var state_machine: = $StateMachine
@onready var animation_player = $AnimationPlayer
@onready var attack_wait_timer = $AttackWaitTimer

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_physical_attack_power: float = 2.0
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 60.0
@export var base_attack_speed: float = 100.0
@export var base_attack_distance: float = 15.0
@export var base_projectile_speed: float = 150.0
@export var base_rotation_speed: float = 8.0
@export var base_knockback: float = 100.0
@export var base_attack_wait_time: float = 3.0

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var attack_speed: float = base_attack_speed
var attack_distance: float = base_attack_distance
var projectile_speed: float = base_projectile_speed
var rotation_speed: float = base_rotation_speed
var knockback: float = base_knockback
var attack_wait_time: float = base_attack_wait_time
var damage: float = 0.0

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var enemies: Array = []
var isAttacking: bool = false
var target: CharacterBody2D = null
var targetPos: Vector2 = Vector2()
var appearPos: Vector2 = Vector2()
var finished: bool = false

func _ready() -> void:
	'''
	初始化

	:return: void
	'''
	# 监听玩家属性节点的属性变化事件，更新武器的属性
	_update_parameters()
	playerStats.connect("stats_changed", _on_stats_changed)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	APPEAR,
	WAIT,
	CHARGE,
	ATTACK,
	LANDING,
	DISAPPEAR,
}
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR:
			position = slot.global_position
		State.WAIT:
			position = slot.global_position
			rotation = lerp_angle(rotation, -PI/2, rotation_speed*delta)
		State.CHARGE:
			var dir := (targetPos - global_position).normalized()
			rotation := lerp_angle(rotation, dir.angle(), rotation_speed*delta)
			# 更新对象的旋转角度
			rotation = currentAngle
		State.ATTACK:
			if not animation_player.is_playing():
				position = position.move_toward(targetPos, projectile_speed*delta)
				if position.distance_to(targetPos) < 0.1:
					finished = true
		State.LANDING:
			position = position.move_toward(targetPos, projectile_speed*delta)
		State.DISAPPEAR:
			pass

func get_next_state(state: State) -> int:
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				finished = false
				return State.WAIT
		State.WAIT:
			target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
			if target  and attack_wait_timer.is_stopped():
				finished = false
				return State.CHARGE
		State.CHARGE:
			var targetDirection := targetPos - global_position
			var targetAngle := targetDirection.angle() - PI/2
			# 检查旋转是否完成
			var angleDifference : float = abs(fposmod(rotation - targetAngle + PI, 2 * PI) - PI)
			if angleDifference < 0.01:  # 0.01 是一个自定义的小阈值，表示两个角度非常接近时的差异
				return State.ATTACK
		State.ATTACK:
			if finished:
				finished = false
				return State.LANDING
		State.LANDING:
			if recovery_timer.is_stopped():
				return State.DISAPPEAR
		State.DISAPPEAR:
			if not animation_player.is_playing():
				return State.APPEAR
			
	return StateMachine.KEEP_CURRENT
	

func transition_state(from: State, to: State) -> void:
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.APPEAR:
			hit_box.monitoring = false
			animation_player.play("appear")
		State.WAIT:
			hit_box.monitoring = false
			attack_wait_timer.start()
		State.CHARGE:
			var dir := target.global_position - global_position
			targetPos = target.global_position + dir.normalized() * attack_distance
		State.ATTACK:
			animation_player.play("charge")
			hit_box.monitoring = true
		State.LANDING:
			recovery_timer.start()
			hit_box.monitoring = false
			animation_player.play("landing")
		State.DISAPPEAR:
			hit_box.monitoring = false
			animation_player.play("disappear")
		
		

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _update_parameters() -> void:
	'''
	从玩家的属性节点中获取属性值，并更新武器的属性
	
	:return: void
	'''
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	attack_speed = base_attack_speed * playerStats.attack_speed_multiplier
	projectile_speed =base_projectile_speed * playerStats.projectile_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	knockback = base_knockback * playerStats.knockback_multiplier
	
	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	attack_wait_timer.wait_time = attack_wait_time
	
	damage = physical_attack_power + magic_attack_power 

func _on_stats_changed() -> void:
	_update_parameters()
