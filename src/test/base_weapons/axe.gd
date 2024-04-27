extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 武器基类 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var slot: Node2D
var player: CharacterBody2D
var playerStats: Node

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var hit_box = $Graphics/HitBox
@onready var searching_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_pick_up: Area2D = $AreaPickUp
@onready var state_machine: = $StateMachine
@onready var animation_player = $AnimationPlayer
@onready var attack_wait_timer = $AttackWaitTimer

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_physical_attack_power: float = 5.0
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 100.0
@export var base_projectile_speed: float = 450.0
@export var base_rotation_speed: float = 15.0
@export var base_knockback: float = 300.0
@export var base_attack_wait_time: float = 3.0

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var physical_attack_power: float
var magic_attack_power: float
var attack_range: float
var projectile_speed: float
var rotation_speed: float
var knockback: float
var damage: float = 0.0

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var enemies: Array = []
var isAttacking: bool = false
var target: CharacterBody2D = null
var targetPos: Vector2 = Vector2()
var appearPos: Vector2 = Vector2()
var picked_up: bool = false

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

func _on_area_pick_up_body_entered(body: Node2D) -> void:
	picked_up = true

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
			rotation = -PI/2
		State.WAIT:
			position = slot.global_position
		State.CHARGE:
			pass
		State.ATTACK:
			var dir := (targetPos - position).normalized()
			rotation = lerp_angle(rotation, dir.angle(), rotation_speed*delta)
			position = position.move_toward(targetPos, projectile_speed*delta)
		State.LANDING:
			pass
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
				var dir := (target.global_position - position).normalized()
				targetPos = position + dir * attack_range
				if dir.x < 0:
					scale.y = -1
				else:
					scale.y = +1
				return State.CHARGE
		State.CHARGE:
			if not animation_player.is_playing():
				return State.ATTACK
		State.ATTACK:
			if position.distance_to(targetPos) < 0.1:
				return State.LANDING
		State.LANDING:
			if attack_wait_timer.is_stopped() or picked_up:
				return State.DISAPPEAR
		State.DISAPPEAR:
			if not animation_player.is_playing():
				return State.APPEAR
			
	return StateMachine.KEEP_CURRENT
	

func transition_state(from: State, to: State) -> void:
	# print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.APPEAR:
			animation_player.play("appear")
		State.WAIT:
			pass
		State.CHARGE:
			animation_player.play("charge")
		State.ATTACK:
			# 归零 scale position rotation
			var total_time = position.distance_to(targetPos) / projectile_speed
			var tween1 = get_tree().create_tween()
			tween1.tween_property($Graphics, "scale", Vector2(1.0, 1.0), total_time)
			var tween2 = get_tree().create_tween()
			tween2.tween_property($Graphics, "position", Vector2.ZERO, 0.15)
			var tween3 = get_tree().create_tween()
			tween3.tween_property($Graphics, "rotation", 0.0, 0.15)
			hit_box.monitoring = true
		State.LANDING:
			attack_wait_timer.start()
			area_pick_up.monitoring = true
			hit_box.monitoring = false
			animation_player.play("landing")
		State.DISAPPEAR:
			area_pick_up.monitoring = false
			picked_up = false
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
	projectile_speed =base_projectile_speed * playerStats.projectile_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	knockback = base_knockback * playerStats.knockback_multiplier
	
	searching_shape_2d.shape.radius = attack_range
	attack_wait_timer.wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	
	damage = physical_attack_power + magic_attack_power 

func _on_stats_changed() -> void:
	_update_parameters()


