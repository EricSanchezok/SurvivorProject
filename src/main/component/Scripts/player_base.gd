class_name PlayerBase
extends CharacterBody2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var hurt_box: HurtBox = $Graphics/HurtBox
@onready var player_stats: PlayerStats = $PlayerStats
@onready var abm: AttributesManager = $AttributesManager
@onready var shop_screen: Control = $CanvasLayer/ShopScreen
@onready var nature_trait: NatureTrait = $Traits/NatureTrait


signal register_weapon(player: CharacterBody2D, weaponName: String, slot_index: int)
signal unregister_weapon(player: CharacterBody2D, slot_index: int)

signal esc_pressed

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 羁绊相关 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
signal origins_number_changed(type, value)
signal classes_number_changed(type, value)
signal attribute_count_changed()
var origins_count: Array[int] 
func update_origins_number(type, value):
	origins_count[type] += value
	attribute_count_changed.emit()
	origins_number_changed.emit(type, value)
var classes_count: Array[int] 
func update_classes_number(type, value):
	classes_count[type] += value
	attribute_count_changed.emit()
	classes_number_changed.emit(type, value)

enum Direction {
	LEFT = -1,
	RIGHT = +1
}

@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		$Graphics.scale.x = direction
		
		
var interacting_with: Array[Interactable]
		
var pending_damage: Damage
var slots = []

var slot_height: float = -25.0
var slot_space: float = 12.0
var slot_radius: float = 36.0
var slot_speed_rotation: float = 60.0
var amplitude: float = 2.0
var frequency: float = 0.2
var current_time: float = 0.0

func _ready() -> void:
	camera_2d.enabled = is_multiplayer_authority()
	
	origins_count.resize(AttributesManager.Origins.size())
	origins_count.fill(0)
	classes_count.resize(AttributesManager.Classes.size())
	classes_count.fill(0)
	slots = get_tree().get_nodes_in_group("weapon_slot")
	init_slots()
	
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	IDLE,
	RUN,
	DIE,
	HURT,
}

func tick_physics(state: State, delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	move_slots(delta)
	# 受到伤害闪烁效果
	$Graphics.modulate.a = (sin(Time.get_ticks_msec() / 20.0) * 0.5 + 0.5) if $InvincibleTimer.time_left > 0.0 else 1.0
	match state:
		State.IDLE, State.DIE:
			stand()
		State.RUN, State.HURT:
			move(delta)

func get_next_state(state: State) -> int:
	if pending_damage:
		return State.HURT

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
		State.HURT:
			if not $AnimationPlayer.is_playing():
				return State.IDLE
		State.DIE:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
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
			$AnimationPlayer.play("idle")
		State.RUN:
			$AnimationPlayer.play("run")
		State.HURT:
			if player_stats.health_shield > 0:
				player_stats.health_shield -=pending_damage.amount
			player_stats.health -= pending_damage.amount
			pending_damage = null
			print(player_stats.health)
			$AnimationPlayer.play("hurt")
		State.DIE:
			$AnimationPlayer.play("die")
			

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 功能函数 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func register_interactable(v: Interactable) -> void:
	if v in interacting_with:
		return
	
	for _v in interacting_with:
		_v.unhighlight()
	v.highlight()
	interacting_with.append(v)

	
func unregister_interactable(v: Interactable) -> void:
	interacting_with.erase(v)
	v.unhighlight()


func recover_from_shop_screen() -> void:
		var tween = create_tween()
		tween.parallel().tween_property(camera_2d, "drag_left_margin", 0.1, 0.3)
		tween.parallel().tween_property(camera_2d, "drag_top_margin", 0.1, 0.3)
		tween.parallel().tween_property(camera_2d, "drag_right_margin", 0.1, 0.3)
		tween.parallel().tween_property(camera_2d, "drag_bottom_margin", 0.1, 0.3)

func stand() -> void:
	'''
		站立状态下，不做任何事情
	
	:return: None
	'''
	pass
	
func move(delta: float) -> void:
	'''
		移动状态下，根据输入方向移动

	:param delta: 逻辑帧间隔时间
	:return: None
	'''
	var movement := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if not movement.is_zero_approx():
		direction = Direction.LEFT if movement.x < 0 else Direction.RIGHT
	var max_movement_speed = player_stats.base_movement_speed * player_stats.movement_speed_multiple
	velocity = movement.normalized() * max_movement_speed
	move_and_collide(velocity*delta)
	
func get_weapon_slot(index: int) -> Marker2D:
	'''
		获取指定索引的武器槽

	:param index: 武器槽索引
	:return: 武器槽
	'''
	return slots[index]


func init_slots() -> void:
	'''
		初始化武器槽的位置

	:return: None
	'''
	for i in range(0, 5):
		slots[i].position = Vector2(-2*slot_space + i * slot_space, slot_height)
	for i in range(5, 10):
		slots[i].position = Vector2(cos(deg_to_rad(72 * (i - 5))) * slot_radius, sin(deg_to_rad(72 * (i - 5))) * slot_radius)

func move_slots(delta) -> void:
	'''
		移动武器槽的位置，使其呈现出动态效果

	:param delta: 逻辑帧间隔时间
	:return: None
	'''
	for i in range(0, 5):
		slots[i].position.y = slot_height + sin(current_time + i * frequency) * amplitude
	for i in range(5, 10):
		slots[i].position = Vector2(
			cos(deg_to_rad(72 * (i - 5) + slot_speed_rotation*current_time)) * slot_radius,
			sin(deg_to_rad(72 * (i - 5) + slot_speed_rotation*current_time)) * slot_radius,
		)
	current_time += delta
	
	
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 回调函数 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shop"):
		if not shop_screen.visible:
			camera_2d.position_smoothing_enabled = false
			var tween = create_tween()
			tween.parallel().tween_property(camera_2d, "drag_left_margin", 0.0, 0.3)
			tween.parallel().tween_property(camera_2d, "drag_top_margin", 0.0, 0.3)
			tween.parallel().tween_property(camera_2d, "drag_right_margin", 0.0, 0.3)
			tween.parallel().tween_property(camera_2d, "drag_bottom_margin", 0.0, 0.3)
			await tween.finished
			camera_2d.position_smoothing_enabled = true
			shop_screen.show_screen()
		else:
			shop_screen.hide_screen()
			recover_from_shop_screen()
			
	if event.is_action_pressed("interact") and interacting_with:
		interacting_with.back().interact(self)

	if event.is_action_pressed("esc"):
		# print("哦耶，我按下了ESC")
		esc_pressed.emit()
