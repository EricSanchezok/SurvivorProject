class_name Boomerang
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
@onready var recall_timer: Timer = $RecallTimer
@onready var attack_wait_timer: Timer = $AttackWaitTimer

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_recall_time: float = 0.5
@export var base_physical_attack_power: float = 2.0
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 100.0
@export var base_projectile_speed: float = 140.0
@export var base_rotation_speed: float = 15.0
@export var base_knockback: float = 30.0
@export var base_attack_wait_time: float = 1.0

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
var targetDirection : Vector2 = Vector2()
var recall_time: float


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

func _on_hit_box_hit(hurtbox: Variant) -> void:
	if recall_time > 0:
		recall_time += 0.2

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	APPEAR,
	WAIT,
	ATTACK,
	RECALL,
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR:
			position = slot.global_position
			rotation = -PI/2
		State.WAIT:
			position = slot.global_position
			rotation = lerp_angle(rotation, -PI/2, rotation_speed * delta)
		State.ATTACK:
			rotation += rotation_speed * delta
			position += targetDirection.normalized() * projectile_speed * delta
			recall_time -= delta
		State.RECALL:
			rotation += rotation_speed * delta
			position = position.move_toward(slot.global_position, projectile_speed*delta)

func get_next_state(state: State) -> int:
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.WAIT
		State.WAIT:
			target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
			if target and attack_wait_timer.is_stopped():
				targetDirection = (target.global_position - position).normalized()
				return State.ATTACK
		State.ATTACK:
			if recall_time < 0:
				return State.RECALL
		State.RECALL:
			if position.distance_to(slot.global_position) < 2.0:
				return State.WAIT
	return StateMachine.KEEP_CURRENT
	

func transition_state(from: State, to: State) -> void:
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.APPEAR:
			animation_player.play("appear")
		State.WAIT:
			hit_box.monitoring = false
			attack_wait_timer.start()
		State.ATTACK:
			recall_time = base_recall_time * playerStats.attack_speed_multiplier
			hit_box.monitoring = true
		State.RECALL: 
			pass
		
		
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


