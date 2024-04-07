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


@export var direction := Direction.LEFT:
	set(v):
		direction = v
		if not is_node_ready():
			await  ready
		graphics.scale.x = direction

var random := RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()
	
func die() -> void:
	queue_free()
	
	
func tick_physics(state: State, delta: float) -> void:

	match state:
		State.APPEAR, State.DIE:
			pass
		State.RUN:
			move(delta)

	
func get_random_target() -> Player:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return null
	return players[random.randi() % players.size()]

func move_to_target(target: Player, delta: float) -> void:
	var target_position := target.global_position
	var position := global_position
	var direction := (target_position - position).normalized()
	
	velocity = direction * enemy_stats.base_movement_speed
	direction = velocity.x < 0 ? Direction.LEFT : Direction.RIGHT


	
	
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

