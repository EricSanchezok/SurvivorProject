extends Node2D

@onready var state_machine: StateMachine = $StateMachine

# 基础属性
@export var base_max_health: float = 20.0
@export var base_health_regeneration: float = 1.0
@export var base_recovery_time: float = 5.0
@export var base_physical_attack_power: float = 3.0
@export var base_magic_attack_power: float = 0.0
@export var base_knockback: float = 50.0

# 当前属性
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
	PREPARED,
	RECOVERING
}

@onready var parentNode: Node2D = get_parent()
@onready var playerStats: Node = parentNode.get_parent().get_parent().get_node("PlayerStats")

func _ready() -> void:
	_update_parameters()
	playerStats.connect("max_health_multiplier_changed", _on_changed_max_health_multiplier_multiplier)
	playerStats.connect("health_regeneration_multiplier_changed", _on_changed_health_regeneration_multiplier)
	playerStats.connect("physical_attack_power_multiplier_changed", _on_changed_physical_attack_power_multiplier)
	playerStats.connect("magic_attack_power_multiplier_changed", _on_changed_magic_attack_power_multiplier)
	playerStats.connect("attack_power_multiplier_changed", _on_changed_attack_power_multiplier)
	playerStats.connect("knockback_multiplier_changed", _on_changed_knockback_multiplier)
	playerStats.connect("damage_reduction_rate_changed", _on_changed_damage_reduction_rate)
	health = max_health


func _on_hit_box_hit(hurtbox: Variant) -> void:
	pending_damage = Damage.new()
	pending_damage.source = hurtbox.owner
	pending_damage.amount = pending_damage.source.enemyStats.attack_power * (1 - damage_reduction_rate)


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.PREPARED:
			pass
		State.RECOVERING:
			pass
			
func get_next_state(state: State) -> int:
	if health <= 0:
		return StateMachine.KEEP_CURRENT if state == State.RECOVERING else State.RECOVERING
	
	match state:
		State.PREPARED:
			pass
		State.RECOVERING:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])
	
	match to:
		State.PREPARED:
			pass
		State.RECOVERING:
			pass




# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _update_parameters() -> void:
	'''
	从玩家的属性节点中获取属性值，并更新武器的属性
	
	:return: void
	'''
	max_health = base_max_health * playerStats.max_health_multiplier
	health_regeneration = base_health_regeneration * playerStats.health_regeneration_multiplier
	recovery_time = base_recovery_time / playerStats.health_regeneration_multiplier
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	knockback = base_knockback * playerStats.knockback_multiplier
	damage_reduction_rate = playerStats.damage_reduction_rate
	damage = physical_attack_power + magic_attack_power 

func _on_changed_max_health_multiplier_multiplier() -> void:
	max_health = base_max_health * playerStats.max_health_multiplier

func _on_changed_health_regeneration_multiplier() -> void:
	health_regeneration = base_health_regeneration * playerStats.health_regeneration_multiplier
	recovery_time = base_recovery_time / playerStats.health_regeneration_multiplier

func _on_changed_physical_attack_power_multiplier() -> void:
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	damage = physical_attack_power + magic_attack_power

func _on_changed_magic_attack_power_multiplier() -> void:
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	damage = physical_attack_power + magic_attack_power

func _on_changed_attack_power_multiplier() -> void:
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	damage = physical_attack_power + magic_attack_power

func _on_changed_knockback_multiplier() -> void:
	knockback = base_knockback * playerStats.knockback_multiplier

func _on_changed_damage_reduction_rate() -> void:
	damage_reduction_rate = playerStats.damage_reduction_rate



