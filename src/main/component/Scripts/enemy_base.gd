class_name EnemyBase
extends CharacterBody2D

@onready var enemy_stats: EnemyStats = $EnemyStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var freezing_timer: Timer = $FreezingTimer

enum Direction {
	LEFT = -1,
	RIGHT = +1,
}

var pending_damages: Array
var target: CharacterBody2D
var random := RandomNumberGenerator.new()
var is_dead: bool = false

@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await  ready
		$Graphics.scale.x = direction
		
class SlowEffect:  #减速效果类
	var amount: float  # 减速的百分比
	var duration: float  # 减速持续的时间（秒）

var slow_effects: Array = []


func _ready() -> void:
	random.randomize()
	target = get_random_target()
	
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	APPEAR,
	RUN,
	DIE,
	HURT,
}

func tick_physics(state: State, delta: float) -> void:
	for i in range(len(slow_effects) - 1, -1, -1):
		var effect = slow_effects[i]
		effect.duration -= delta
		if effect.duration <= 0:
			slow_effects.remove_at(i)
	 # 应用最大减速
	if slow_effects.size() > 0:
		var max_slow = slow_effects[0].amount  # 直接使用数组第一个元素的减速幅度
		enemy_stats.speed_movement = enemy_stats.base_speed_movement * (1-max_slow)
	match state:
		State.APPEAR, State.DIE:
			pass
		State.HURT:
			for damage in pending_damages:
				enemy_stats.health -= damage.amount
				velocity -= damage.dir * damage.knockback
				pending_damages.erase(damage)
			move_and_slide()
		State.RUN:
			move_to_target()
			pass
			
func get_next_state(state: State) -> int:
	if pending_damages.size() > 0:
		return StateMachine.KEEP_CURRENT if state == State.HURT else State.HURT

	if enemy_stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.RUN
		State.RUN:
			pass
		State.HURT:
			if not animation_player.is_playing():
				return State.RUN
		State.DIE:
			pass

				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.APPEAR:
			var dir := (target.global_position - position).normalized()
			direction = Direction.RIGHT if dir.x > 0 else Direction.LEFT
			animation_player.play("appear")
		State.RUN:
			animation_player.play("run")
		State.HURT:
			animation_player.play("hurt")
		State.DIE:
			animation_player.play("die")
		
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 功能函数 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func get_random_target() -> PlayerBase:
	'''
		获取随机玩家对象
	
	return: 随机玩家对象
	'''
	var players := get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return null
	return players[random.randi_range(0, players.size() - 1)]

func move_to_target() -> void:
	'''
		移动到目标
	
	param target: 目标
	param delta: 时间间隔
	'''
	if target == null:
		return
	var target_position := target.global_position
	var pos := global_position
	var dir := (target_position - pos).normalized()
	velocity = dir * enemy_stats.speed_movement
	direction = Direction.RIGHT if velocity.x > 0 else Direction.LEFT
	move_and_slide()
	
func die() -> void:
	'''
		死亡
	'''
	is_dead = true
	await not animation_player.is_playing()
	queue_free()


func _on_hurt_box_hurt(hitbox: Variant) -> void:
	var damage = Damage.new()
	damage.source = hitbox.owner
	damage.dir = (hitbox.owner.global_position - position).normalized()
	damage.amount = hitbox.owner.power_physical + hitbox.owner.power_magic
	damage.knockback = hitbox.owner.knockback * (1 - enemy_stats.knockback_resistance)
	add_slow_effect(hitbox.owner.deceleration_rate,hitbox.owner.deceleration_time)
	damage.freezing_rate = hitbox.owner.freezing_rate
	pending_damages.append(damage)
	#print(pending_damages.size())
	
	
func add_slow_effect(amount, duration):
	var new_effect = SlowEffect.new()
	new_effect.amount = amount
	new_effect.duration = duration
	slow_effects.append(new_effect)
	slow_effects.sort_custom(compare_slow_effects)

func compare_slow_effects(a, b):
	if a.amount > b.amount:
		return true
	else:
		return false

