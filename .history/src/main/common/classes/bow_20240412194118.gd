class_name Bow
extends Node2D


@onready var area_2d: Area2D = $Area2D
@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var marker_2d: Marker2D = $Marker2D


@export var base_physical_attack_power: float = 0.5
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 500.0 # 自动索敌的范围
@export var base_attack_speed: float = 200.0
@export var base_rotation_speed: float = 15.0
@export var base_attack_wait_time: float = 0.5
@export var base_knockback: float = 30.0

var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var attack_speed: float = base_attack_speed
var rotation_speed: float = base_rotation_speed
var attack_wait_time: float = base_attack_wait_time
var knockback: float = base_knockback

@onready var bullets = {
	"normal_arrow": preload("res://src/main/scene/role/weapons/Bullet/normal_arrow.tscn"),
}

var enemies: Array = []

var damage: float = 0.0

enum State {
	WAIT,
	AMING,
	FIRE,


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


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			pass
		State.AMING:
			pass
		State.FIRE:
			pass

			
func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			pass
		State.AMING:
			pass
		State.FIRE:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])

	match state:
		State.WAIT:
			pass
		State.AMING:
			pass
		State.FIRE:
			pass
