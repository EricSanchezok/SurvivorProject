extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 武器基类 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var slot: Node2D
var player: CharacterBody2D
var playerStats: Node

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var hit_shape_2d: CollisionShape2D = $Graphics/HitBox/CollisionShape2D
@onready var searching_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var hit_box: HitBox = $Graphics/HitBox
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_physical_attack_power: float =3.0  #物理攻击力
@export var base_magic_attack_power: float = 3.0   #魔法攻击力
@export var base_attack_range: float = 150.0 #自动索敌的范围
@export var base_attack_speed: float = 300.0  #攻击速度
@export var base_rotation_speed: float = 15.0   #旋转速度
@export var base_attack_wait_time: float = 1.5   #攻击间隔
@export var base_knockback: float = 0    #击退效果
@export var base_critical_hit_rate: float = 0.0  #暴击率
@export var base_critical_damage: float = 1.5    #暴击伤害
@export var base_number_of_projectiles: int = 1   #发射物数量
@export var base_projectile_speed: float = 200.0   #发射物速度

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var physical_attack_power: float
var magic_attack_power: float
var damage: float = 0.0 # 能够造成的总伤害
var attack_range: float
var attack_speed: float
var rotation_speed: float
var attack_wait_time: float
var knockback: float
var critical_hit_rate: float
var critical_damage: float
var number_of_projectiles: int
var projectile_speed: float
var current_time :float = 0

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 特殊属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_explosion_range: = 50   #爆炸范围
var explosion_range: float 
@export var base_number_of_bounces: = 0   #弹跳次数
var number_of_bounces: float = base_number_of_bounces + base_number_of_projectiles
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var enemies: Array = []
var isAttacking: bool = false
var target: CharacterBody2D = null
var targetPos: Vector2 = Vector2()
var appearPos: Vector2 = Vector2()
var next_point = Vector2.ZERO
var total_time: float =0
var dir: Vector2 = Vector2()
var t:float = 0
var start_position: = Vector2.ZERO
var real_distance:float = 0

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

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 参数更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _update_parameters() -> void:
	'''
	更新武器的属性

	:return: void
	'''
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	damage = physical_attack_power + magic_attack_power
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	searching_shape_2d.shape.radius = attack_range
	attack_speed = base_attack_speed * playerStats.attack_speed_multiplier
	animation_player.speed_scale = playerStats.attack_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	attack_wait_timer.wait_time = attack_wait_time
	knockback = base_knockback * playerStats.knockback_multiplier
	#critical_hit_rate=base_critical_hit_rate + playerStats.critical_hit_rate
	critical_damage = base_critical_damage + playerStats.critical_damage
	number_of_projectiles=base_number_of_projectiles + playerStats.number_of_projectiles
	projectile_speed = base_projectile_speed * playerStats.projectile_speed_multiplier
	
	explosion_range = base_explosion_range * playerStats.attack_range_multiplier
	hit_shape_2d.shape.radius = explosion_range
	number_of_bounces = base_number_of_bounces + base_number_of_projectiles


func _on_stats_changed() -> void:
	_update_parameters()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	APPEAR,
	WAIT,
	ATTACK,
	DISAPPEAR,
}
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR:
			position = slot.global_position
			rotation = -PI/2
		State.WAIT:
			position = slot.global_position
		State.ATTACK:
			set_next_point(delta)
			position = position.move_toward(next_point, projectile_speed*delta)
			hit_box.monitoring = false
			# 检查是否到达目标位置
			if position.distance_to(targetPos) < 1:  # 10为到达距离阈值
				hit_box.monitoring = true
				current_time  = 0
				if number_of_bounces > 0:
					# 计算弹跳目标位置
					real_distance = real_distance*0.5
					var bounce_target = targetPos + dir*real_distance  # 向后弹跳50%
					number_of_bounces -= 1
					targetPos = bounce_target  # 更新目标位置为新的弹跳目标
		State.DISAPPEAR:
			pass


func get_next_state(state: State) -> int:
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.WAIT
		State.WAIT:
			target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
			if target:
				targetPos = target.global_position
				dir = (targetPos - position).normalized()
				real_distance = position.distance_to(targetPos)
				total_time = real_distance / projectile_speed
				if dir.x < 0:
					scale.y = -1
				else:
					scale.y = +1
				return State.ATTACK
		State.ATTACK:
			# 如果没有更多的弹跳，并且到达目标位置
			if number_of_bounces < 1 and position.distance_to(targetPos) < 1:
				return State.DISAPPEAR
		State.DISAPPEAR:
			if not animation_player.is_playing():
				return State.APPEAR
			
	return StateMachine.KEEP_CURRENT
	

func transition_state(from: State, to: State) -> void:
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.APPEAR:
			animation_player.play("appear")
			number_of_bounces = base_number_of_bounces + base_number_of_projectiles
		State.WAIT:
			attack_wait_timer.start()
		State.ATTACK:
			pass
		State.DISAPPEAR:
			animation_player.play("disappear")

func set_next_point(delta):

	current_time += delta
	t = min(current_time / total_time, 1)
	var start_control_point = (position + targetPos) / 2 + Vector2(0, -50)
	next_point = position.bezier_interpolate(start_control_point, targetPos, targetPos, t)

