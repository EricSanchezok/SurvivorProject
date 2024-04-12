class_name Sword
extends Node2D

# 节点引用
@onready var area_2d: Area2D = $Area2D
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var hit_box: HitBox = $Graphics/HitBox

@onready var parentNode: Node2D = get_parent()
@onready var player: CharacterBody2D = get_parent().get_parent().get_parent()
@onready var playerStats: Node = player.get_node("PlayerStats")


# 基础属性
@export var base_physical_attack_power: float = 2.0
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 60.0
@export var base_attack_windup_speed: float = 150.0
@export var base_attack_backswing_speed: float = 120.0
@export var base_rotation_speed: float = 8.0
@export var base_attack_wait_time: float = 0.3
@export var base_knockback: float = 100.0


# 当前属性
var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var attack_windup_speed: float = base_attack_windup_speed
var attack_backswing_speed: float = base_attack_backswing_speed
var rotation_speed: float = base_rotation_speed
var attack_wait_time: float = base_attack_wait_time
var knockback: float = base_knockback

var enemies: Array = []
var isAttacking: bool = false
var target: CharacterBody2D = null
var targetPos: Vector2 = Vector2()

var damage: float = 0.0

# 攻击状态
var isWindupPhase: bool = false
var isBackswingPhase: bool = false

var isBezier: bool = true

func _ready() -> void:
	'''
	初始化

	:return: void
	'''
	# 监听玩家属性节点的属性变化事件，更新武器的属性
	_update_parameters()
	playerStats.connect("stats_changed", _on_stats_changed)


func _process(delta: float) -> void:
	'''
	每帧更新武器的状态

	:param delta: float 时间间隔
	:return: void
	'''
	# 如果不在攻击状态，且攻击等待计时器已经停止
	if not isAttacking and attack_wait_timer.is_stopped():
		# 获取最近的敌人
		target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
		if target:
			# 开始攻击
			start_attack()
	if isWindupPhase:
		perform_windup(delta)
	elif isBackswingPhase:
		perform_backswing(delta)

func start_attack() -> void:
	'''
	开始攻击

	:return: void
	'''
	isAttacking = true
	isWindupPhase = true
	isBackswingPhase = false
	hit_box.monitoring = true
	# 计算伤害
	damage = physical_attack_power + magic_attack_power

func perform_windup(delta: float) -> void:
	'''
	执行武器的攻击前摇动作

	:param delta: float 时间间隔
	:return: void
	'''
	if not target:
		pass
	else:
		targetPos = target.global_position
	var targetDirection = (targetPos - global_position).normalized()
	rotation = lerp_angle(rotation, targetDirection.angle()-PI/2, rotation_speed*delta)

	var distanceToTarget = global_position.distance_to(targetPos)
	var totalTime = distanceToTarget / attack_windup_speed

	if totalTime > 0.01:
		global_position = Tools.move_towards_target(player, attack_windup_speed, global_position, targetPos, delta)
	else:
		transition_to_backswing()

func perform_backswing(delta: float) -> void:
	'''
	执行武器的攻击后摇动作

	:param delta: float 时间间隔
	:return: void
	'''
	rotation = lerp_angle(rotation, parentNode.rotation, rotation_speed*delta*1.5)

	var distanceToParent = global_position.distance_to(parentNode.global_position)
	var totalTime = distanceToParent / attack_backswing_speed

	if totalTime > 0.01:
		global_position = Tools.move_towards_target(player, attack_backswing_speed, global_position, parentNode.global_position, delta)
	else:
		end_attack()

func transition_to_backswing() -> void:
	'''
	切换到攻击后摇阶段

	:return: void
	'''
	isWindupPhase = false
	isBackswingPhase = true
	hit_box.monitoring = false

func end_attack() -> void:
	'''
	结束攻击

	:return: void
	'''
	isBackswingPhase = false
	isAttacking = false
	attack_wait_timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _update_parameters() -> void:
	'''
	从玩家的属性节点中获取属性值，并更新武器的属性
	
	:return: void
	'''
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	attack_windup_speed = base_attack_windup_speed * playerStats.attack_speed_multiplier
	attack_backswing_speed = base_attack_backswing_speed * playerStats.attack_speed_multiplier
	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	
	attack_wait_timer.wait_time = attack_wait_time
	knockback = base_knockback * playerStats.knockback_multiplier

	area_2d.scale = Vector2(attack_range/10.0, attack_range/10.0)

func _on_stats_changed() -> void:
_update_parameters()
func _on_changed_magic_attack_power_multiplier() -> void:
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier

func _on_changed_attack_power_multiplier() -> void:
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier

func _on_changed_attack_range_multiplier() -> void:
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	area_2d.scale = Vector2(attack_range/10.0, attack_range/10.0)

func _on_changed_attack_speed_multiplier() -> void:
	attack_windup_speed = base_attack_windup_speed * playerStats.attack_speed_multiplier
	attack_backswing_speed = base_attack_backswing_speed * playerStats.attack_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	attack_wait_timer.wait_time = attack_wait_time

func _on_changed_knockback_multiplier() -> void:
	knockback = base_knockback * playerStats.knockback_multiplier
