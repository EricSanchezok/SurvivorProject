class_name Shield
extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 武器基类 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var slot: Node2D
var player: CharacterBody2D
var playerStats: Node


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var recovery_timer: Timer = $RecoveryTimer
@onready var hit_box: HitBox = $Graphics/HitBox
@onready var health_regeneration_timer: Timer = $HealthRegenerationTimer

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_max_health: float = 10.0
@export var base_health_regeneration: float = 0.5
@export var base_recovery_time: float = 5.0
@export var base_physical_attack_power: float = 3.0
@export var base_magic_attack_power: float = 0.0
@export var base_knockback: float = 80.0

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var max_health: float = base_max_health
var health_regeneration: float = base_health_regeneration
var recovery_time: float = base_recovery_time
var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var knockback: float = base_knockback
var damage_reduction_rate: float = 0.0

var health: float = 0.0
var damage: float = 0.0
var pending_damage: Damage

enum State {
	APPEAR,
	PREPARED,
	RECOVERING,
	HURT,
}

@onready var parentNode: Node2D = get_parent()
@onready var playerStats: Node = parentNode.get_parent().get_parent().get_node("PlayerStats")

func _ready() -> void:
	_update_parameters()
	playerStats.connect("stats_changed", _on_stats_changed)
	health = max_health

func _on_hit_box_hit(hurtbox: Variant) -> void:
	'''
	受到伤害

	:param hurtbox: 伤害来源
	:return: void
	'''
	pending_damage = Damage.new()
	pending_damage.source = hurtbox.owner
	# 伤害计算（包含减伤率）
	pending_damage.amount = pending_damage.source.enemyStats.attack_power * (1 - damage_reduction_rate)

func _on_health_regeneration_timer_timeout() -> void:
	'''
	生命值回复
	
	:return: void
	'''
	health = min(health + health_regeneration, max_health)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR:
			pass
		State.PREPARED:
			pass
		State.RECOVERING:
			pass
		State.HURT:
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
	 #print("[%s] %s => %s" % [
	 	#Engine.get_physics_frames()	,
	 	#State.keys()[from] if from != -1 else "<START>",
	 	#State.keys()[to],
	 #])

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

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _update_parameters() -> void:
	'''
	从玩家的属性节点中获取属性值，并更新武器的属性
	
	:return: void
	'''
	max_health = base_max_health * playerStats.max_health_multiplier
	health_regeneration = base_health_regeneration * playerStats.health_regeneration_multiplier
	recovery_time = base_recovery_time / playerStats.health_regeneration_multiplier
	recovery_timer.wait_time = recovery_time

	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	knockback = base_knockback * playerStats.knockback_multiplier
	damage_reduction_rate = playerStats.damage_reduction_rate
	damage = physical_attack_power + magic_attack_power 

func _on_stats_changed() -> void:
	_update_parameters()




