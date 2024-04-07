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

	
func stand(delta: float) -> void:
	pass
	
func move(delta: float) -> void:
	var movement := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if not movement.is_zero_approx():
		direction = Direction.LEFT if movement.x < 0 else Direction.RIGHT
	velocity.x = movement.x * enemy_stats.base_movement_speed
	velocity.y = movement.y * enemy_stats.base_movement_speed
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

