class_name Enemy
extends CharacterBody2D

@onready var enemy_stats: EnemyStats = $EnemyStats
@onready var graphics: Node2D = $Graphics
@onready var state_machine: Node = $StateMachine
@onready var hit_box: Area2D = $Graphics/HitBox
@onready var hurt_box: Area2D = $Graphics/HurtBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum Direction {
	LEFT = -1,
	RIGHT = +1,
}

enum State {
	APPEAR,
	RUN,
	DIE
}

var pending_damage: Damage
var target: Player = null

@export var direction := Direction.LEFT:
	set(v):
		direction = v
		if not is_node_ready():
			await  ready
		graphics.scale.x = direction

var random := RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()
	target = get_random_target()
	print("target: %s" % target)

func die() -> void:
	queue_free()
	
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.APPEAR, State.DIE:
			pass
		State.RUN:
			move_to_target(target, delta)

func get_random_target() -> Player:
	'''
		获取随机玩家对象
	
	return: 随机玩家对象
	'''
	var players := get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return null
	return players[random.randi_range(0, players.size() - 1)]


func move_to_target(target: Player, delta: float) -> void:
	'''
		移动到目标
	
	param target: 目标
	param delta: 时间间隔
	'''
	if target == null:
		return
	var target_position := target.global_position
	var position := global_position
	var dir := (target_position - position).normalized()
	
	direction = Direction.RIGHT if direction.x > 0 else Direction.LEFT

	move_and_slide()

func get_next_state(state: State) -> int:
	if enemy_stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.RUN
		State.RUN:
			pass
		State.DIE:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:
	
	#print("[%s] %s => %s" % [
		#Engine.get_physics_frames()	,
		#State.keys()[from] if from != -1 else "<START>",
		#State.keys()[to],
	#])
	
	match to:
		State.APPEAR:
			animation_player.play("appear")
		State.RUN:
			animation_player.play("run")
		State.DIE:
			# 关闭 hurt_box
			hurt_box.monitorable = false
			
			die()

