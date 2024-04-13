class_name Bow
extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var area_2d: Area2D = $Area2D
@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var marker_2d: Marker2D = $Marker2D
@onready var parentNode: Node2D = get_parent()
@onready var player: CharacterBody2D = get_parent().get_parent().get_parent()
@onready var playerStats: Node = player.get_node("PlayerStats")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_physical_attack_power: float = 0.5
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 150.0 # 自动索敌的范围
@export var base_attack_speed: float = 100.0
@export var base_rotation_speed: float = 15.0
@export var base_attack_wait_time: float = 0.5
@export var base_knockback: float = 30.0

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var physical_attack_power: float
var magic_attack_power: float
var attack_range: float
var attack_speed: float
var rotation_speed: float
var attack_wait_time: float
var knockback: float
var damage: float = 0.0 # 能够造成的总伤害
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 特殊属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var penetration_rate: float = 0.4

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var bullets = {
	"normal_arrow": preload("res://src/main/scene/role/weapons/Bullet/normal_arrow.tscn"),
}
var enemies: Array = []

var target: CharacterBody2D = null

func _ready() -> void:
	'''
	初始化武器

	:return: void
	'''
	_update_parameters()
	playerStats.connect("stats_changed", _on_stats_changed)

func aiming_success() -> bool:
	'''
	判断是否瞄准成功

	:return: bool
	'''
	if not target:
		return true
	var targetDirection := target.global_position - global_position
	var targetAngle := targetDirection.angle() - PI
	return Tools.are_angles_close(rotation, targetAngle)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	WAIT,
	AIMNG
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			pass
		State.AIMNG:
			var targetDirection := target.global_position - global_position
			rotation = lerp_angle(rotation, targetDirection.angle()-PI, rotation_speed*delta)
			
func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
			if target and attack_wait_timer.is_stopped():
				return State.AIMNG
		State.AIMNG:
			if aiming_success() and not animation_player.is_playing():
				attack_wait_timer.start()
				graphics.scale = Vector2(1.0, 1.0)
				var now_bullet = bullets["normal_arrow"].instantiate()
				now_bullet.attack_speed = attack_speed
				now_bullet.damage = damage
				now_bullet.knockback = knockback
				now_bullet.penetration_rate = penetration_rate
				now_bullet.dir = Vector2(1, 0)
				self.add_child(now_bullet)

				return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	print("[%s] %s => %s" % [
		Engine.get_physics_frames()	,
		State.keys()[from] if from != -1 else "<START>",
		State.keys()[to],
	])
	match to:
		State.WAIT:
			pass
		State.AIMNG:
			animation_player.play("aiming")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 参数更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

	knockback = base_knockback * playerStats.knockback_multiplier

	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	attack_wait_timer.wait_time = attack_wait_time

	area_2d.scale = Vector2(attack_range/10.0, attack_range/10.0)

	damage = physical_attack_power + magic_attack_power


func _on_stats_changed() -> void:
	_update_parameters()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)