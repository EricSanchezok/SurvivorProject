class_name Player
extends CharacterBody2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var graphics: Node2D = $Graphics
@onready var playerStats: PlayerStats = $PlayerStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box: HurtBox = $Graphics/HurtBox
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var pause_screen: Control = $CanvasLayer/PauseScreen
@onready var weapons_track: Node2D = $WeaponsTrack

signal register_weapon(player: CharacterBody2D, weaponName: String, weapon_slot: int)
var pending_damage: Damage

enum Direction {
	LEFT = -1,
	RIGHT = +1
}

@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		graphics.scale.x = direction	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_screen.show_pause()

func stand() -> void:
	'''
		站立状态下，不做任何事情
	
	:param delta: 逻辑帧间隔时间
	:return: None
	'''
	velocity = Vector2(0, 0)
	
func move(delta: float) -> void:
	'''
		移动状态下，根据输入方向移动

	:param delta: 逻辑帧间隔时间
	:return: None
	'''
	var movement := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if not movement.is_zero_approx():
		direction = Direction.LEFT if movement.x < 0 else Direction.RIGHT
	var max_movement_speed := playerStats.base_movement_speed * playerStats.movement_speed_multiplier
	velocity = movement.normalized() * max_movement_speed
	move_and_slide()

func _on_hurt_box_hurt(hitbox: Variant) -> void:
	'''
	受到伤害

	:param hurtbox: 伤害来源
	:return: void
	'''
	pending_damage = Damage.new()
	pending_damage.source = hitbox.owner
	# 伤害计算（包含减伤率）
	pending_damage.amount = pending_damage.source.enemyStats.attack_power * (1 - playerStats.damage_reduction_rate)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	IDLE,
	RUN,
	DIE,
	HURT,
}

func tick_physics(state: State, delta: float) -> void:
	# 受到伤害闪烁效果
	graphics.modulate.a = (sin(Time.get_ticks_msec() / 20) * 0.5 + 0.5) if invincible_timer.time_left > 0.0 else 1.0
	match state:
		State.IDLE, State.DIE:
			stand()
		State.RUN, State.HURT:
			move(delta)

func get_next_state(state: State) -> int:
	if pending_damage:
		return State.HURT

	if playerStats.health == 0:
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
		State.HURT:
			if invincible_timer.is_stopped():
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

	match from:
		State.IDLE:
			pass
		State.RUN:
			pass
		State.HURT:
			hurt_box.monitorable = true
		State.DIE:
			pass
	
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.HURT:
			playerStats.health -= pending_damage.amount
			pending_damage = null
			invincible_timer.start()
			hurt_box.monitorable = false
		State.DIE:
			hurt_box.monitorable = false
			



