class_name Player
extends CharacterBody2D

@onready var graphics: Node2D = $Graphics
@onready var player_stats: PlayerStats = $PlayerStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box: HurtBox = $Graphics/HurtBox

@onready var invincible_timer: Timer = $InvincibleTimer
@onready var weapons_track: Node2D = $WeaponsTrack
@onready var weapons: WeaponsInstance = $WeaponsInstance

enum Direction {
	LEFT = -1,
	RIGHT = +1
}

enum State {
	IDLE,
	RUN,
	DIE
}

var pending_damage: Damage

@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		graphics.scale.x = direction	

func tick_physics(state: State, delta: float) -> void:
	# 受击之后闪烁特效
	graphics.modulate.a = (sin(Time.get_ticks_msec() / 20) * 0.5 + 0.5) if invincible_timer.time_left > 0.0 else 1.0
	
	match state:
		State.IDLE, State.DIE:
			stand(delta)
		State.RUN:
			move(delta)

	
func stand(delta: float) -> void:
	pass
	
func move(delta: float) -> void:
	var movement := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if not movement.is_zero_approx():
		direction = Direction.LEFT if movement.x < 0 else Direction.RIGHT
	velocity.x = movement.x * player_stats.base_movement_speed
	velocity.y = movement.y * player_stats.base_movement_speed
	move_and_slide()
	
	
func get_next_state(state: State) -> int:
	if player_stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	
	var movement := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var is_still := movement.is_zero_approx()
	
	match state:
		State.IDLE:
			if not is_still:
				return State.RUN
		State.RUN:
			if is_still:
				return State.IDLE
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
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.DIE:
			invincible_timer.stop()
			# 关闭 hurt_box
			hurt_box.monitorable = false
