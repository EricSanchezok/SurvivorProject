class_name Spear
extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 武器基类 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var slot: Node2D
var player: CharacterBody2D
var playerStats: Node

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var hit_box = $Graphics/HitBox
@onready var searching_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var state_machine: = $StateMachine
@onready var animation_player = $AnimationPlayer
@onready var recall_timer = $RecallTimer
@onready var attack_wait_timer = $AttackWaitTimer

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_physical_attack_power: float = 2.0
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 60.0
@export var base_projectile_speed: float = 150.0
@export var base_rotation_speed: float = 8.0
@export var base_knockback: float = 100.0
@export var base_attack_wait_time: float = 0.8

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var projectile_speed: float = base_projectile_speed
var rotation_speed: float = base_rotation_speed
var knockback: float = base_knockback
var damage: float = 0.0

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var enemies: Array = []
var target: CharacterBody2D = null
var targetPos: Vector2 = Vector2()

func _ready() -> void:
	'''
	初始化

	:return: void
	'''
	# 监听玩家属性节点的属性变化事件，更新武器的属性
	_update_parameters()
	playerStats.connect("stats_changed", _on_stats_changed)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _update_parameters() -> void:
	'''
	从玩家的属性节点中获取属性值，并更新武器的属性
	
	:return: void
	'''
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	projectile_speed =base_projectile_speed * playerStats.projectile_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	knockback = base_knockback * playerStats.knockback_multiplier
	attack_wait_timer.wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	searching_shape_2d.shape.radius = attack_range
	damage = physical_attack_power + magic_attack_power 

func _on_stats_changed() -> void:
	_update_parameters()

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
	RECALL,
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR:
			position = slot.global_position
			rotation = PI/2
		State.WAIT:
			position = slot.global_position
			rotation = lerp_angle(rotation, PI/2, rotation_speed*delta)
		State.CHARGE:
			pass
		State.ATTACK:
			var dir := (targetPos - global_position).normalized()
			rotation = lerp_angle(rotation, dir.angle(), rotation_speed*delta)
			position = position.move_toward(targetPos, projectile_speed*delta)
		State.LANDING:
			position = position.move_toward(targetPos, projectile_speed*delta)
		State.RECALL:
			var dir := (targetPos - global_position).normalized()
			rotation = lerp_angle(rotation, dir.angle(), rotation_speed*delta)
			position = position.move_toward(targetPos, projectile_speed*delta)

func get_next_state(state: State) -> int:
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.WAIT
		State.WAIT:
			target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
			if target and attack_wait_timer.is_stopped():
				return State.CHARGE
		State.CHARGE:
			var targetDirection := targetPos - global_position
			var targetAngle := targetDirection.angle() 
			# 检查旋转是否完成
			var angleDifference : float = abs(fposmod(rotation - targetAngle + PI, 2 * PI) - PI)
			if angleDifference < 0.01:  # 0.01 是一个自定义的小阈值，表示两个角度非常接近时的差异
				return State.ATTACK
		State.ATTACK:
			if position.distance_to(targetPos) < 0.1:
				return State.LANDING
		State.LANDING:
			if not animation_player.is_playing():
				return State.RECALL
		State.RECALL:
			if global_position.distance_to(slot.global_position) < 1:
				return State.WAIT
			
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
			recall_timer.start()
			hit_box.monitoring = false
			animation_player.play("landing")
		State.RECALL:
			hit_box.monitoring = true
			knockback=0
		
		

