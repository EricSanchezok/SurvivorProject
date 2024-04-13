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
@export var base_attack_wait_time: float = 0.5
@export var base_knockback: float = 30.0

var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var attack_speed: float = base_attack_speed
var attack_wait_time: float = base_attack_wait_time
var knockback: float = base_knockback

var enemies: Array = []

var damage: float = 0.0


enum State {
    WAIT,
	AMING,
	FIRE,



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
	if pending_damage:
		return State.HURT

	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.PREPARED
		State.PREPARED:
			if health <= 0:
				return State.RECOVERING
		State.RECOVERING:
			if recovery_timer.is_stopped():
				return State.APPEAR
		State.HURT:
			if not animation_player.is_playing():
				return State.PREPARED
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])

	match from:
		State.APPEAR:
			pass
		State.PREPARED:
			pass
		State.RECOVERING:
			health = max_health
		State.HURT:
			pass
	
	match to:
		State.APPEAR:
			animation_player.play("appear")
		State.PREPARED:
			hit_box.monitoring = true
		State.RECOVERING:
			recovery_timer.start()
			hit_box.monitoring = false
			animation_player.play("disappear")
		State.HURT:
			health -= pending_damage.amount
			pending_damage = null
			animation_player.play("hurt")