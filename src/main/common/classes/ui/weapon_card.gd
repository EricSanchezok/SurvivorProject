class_name WeaponCard
extends Button

@onready var shadow: TextureRect = $Shadow
@onready var card_texture: TextureRect = $CardTexture
@onready var state_machine: StateMachine = $StateMachine
@onready var destroy_shape_cast_2d: ShapeCast2D = $DestroyShapeCast2D


@onready var weapon_icon: TextureRect = $CardTexture/WeaponIcon
@onready var weapon_name: Label = $CardTexture/WeaponName
@onready var weapon_price: Label = $CardTexture/WeaponPrice
@onready var weapon_class: Label = $CardTexture/WeaponClass
@onready var weapon_origin: Label = $CardTexture/WeaponOrigin

signal apply_to_purchase(card: WeaponCard)
signal apply_to_exchange(card: WeaponCard)
signal apply_to_destroy(card: WeaponCard, now_position: Vector2)

var player: PlayerBase
var slot: int

var purchased: bool = false
var start_exchange: bool = false
var to_inventory: bool = false
var to_equipment: bool = false
var adsorption_position: Vector2

var following_mouse: bool = false

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 动效变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var angle_x_max: float = deg_to_rad(0)
var angle_y_max: float = deg_to_rad(0)
var max_offset_shadow: int = 10

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween

@export var spring: float = 400.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 0.6
var displacement: float = 0.0 
var oscillator_velocity: float = 0.0
var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var last_pos: Vector2
var velocity: Vector2


func _ready() -> void:
	# 唯一化 card_texture 的材质
	var materialTemp = card_texture.material.duplicate()
	card_texture.material = materialTemp

func init_card(weapon: WeaponsManager.WeaponPoolItem) -> void:
	await ready
	weapon_icon.texture = load(weapon.icon_path)
	weapon_name.text = weapon.weapon_name
	weapon_price.text = str(weapon.price)
	weapon_class.text = weapon.weapon_class
	weapon_origin.text = weapon.weapon_origin

	
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State{
	INSHOP,
	INVENTORY,
	EQUIPMENT,
	EXCHANGE,
}

func tick_physics(state: State, delta: float) -> void:

	match state:
		State.INSHOP:
			pass
		State.INVENTORY:
			rotate_velocity(delta)
			follow_mouse()
			handle_shadow()
		State.EQUIPMENT:
			rotate_velocity(delta)
			follow_mouse()
			handle_shadow()
		State.EXCHANGE:
			pass

func get_next_state(state: State) -> int:
	
	match state:
		State.INSHOP:
			if purchased:
				return State.INVENTORY
		State.INVENTORY:
			if start_exchange:
				return State.EXCHANGE
		State.EQUIPMENT:
			if start_exchange:
				return State.EXCHANGE
		State.EXCHANGE:
			if to_inventory:
				start_exchange = false
				to_inventory = false
				return State.INVENTORY
			if to_equipment:
				start_exchange = false
				to_equipment = false
				return State.EQUIPMENT
				
				

	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match from:
		State.INSHOP:
			pass
		State.INVENTORY:
			pass
		State.EQUIPMENT:
			print("unregister_weapon")
			player.unregister_weapon.emit(player, slot)
		State.EXCHANGE:
			pass
	
	
	match to:
		State.INSHOP:
			pass
		State.INVENTORY:
			adsorption_position = global_position
		State.EQUIPMENT:
			adsorption_position = global_position
			player.register_weapon.emit(player, weapon_name.text, slot)
		State.EXCHANGE:
			pass

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 功能函数 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func rotate_velocity(delta: float) -> void:
	if not following_mouse: return
	# var center_pos: Vector2 = global_position - (size/2.0)
	
	velocity = (position - last_pos) / delta
	last_pos = position
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	rotation = displacement
	
func handle_shadow() -> void:
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/(center.x)))
	
func follow_mouse() -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - (size/2.0)
	
func handle_mouse_click(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.is_pressed(): # 按下鼠标时
		z_index = 100
		if state_machine.current_state != State.INSHOP:
			following_mouse = true
		
	else: # 松开鼠标时
		z_index = 0
		following_mouse = false
		
		# 重置缩放
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)
		
		if state_machine.current_state != State.INSHOP:
			 # 重置旋转
			if tween_handle and tween_handle.is_running():
				tween_handle.kill()
			tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_handle.tween_property(self, "rotation", 0.0, 0.3)
			
			if destroy_shape_cast_2d.is_colliding(): # 卖出该卡
				apply_to_destroy.emit(self)
				return
	
			apply_to_exchange.emit(self, global_position + size/2.0)

func back() -> void:
	# 回到吸附位置
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", adsorption_position, 0.3)
			
func destroy() -> void:
	card_texture.use_parent_material = true
	if tween_destroy and tween_destroy.is_running():
		tween_destroy.kill()
	tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.tween_property(material, "shader_parameter/dissolve_value", 0.0, 0.5).from(1.0)
	tween_destroy.parallel().tween_property(shadow, "self_modulate:a", 0.0, 0.5)
	# tween_destroy.parallel().tween_property(card_texture, "modulate:a", 0.0, 0.5)
	
	if state_machine.current_state == State.EQUIPMENT:
		player.unregister_weapon.emit(player, slot)
	await tween_destroy.finished
	queue_free()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 回调函数 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _gui_input(event: InputEvent) -> void:

	handle_mouse_click(event)

	if following_mouse: return
	if not event is InputEventMouseMotion: return
	
	## 伪 3D 效果器
	#var mouse_pos: Vector2 = get_local_mouse_position()
	#var diff: Vector2 = (position + size) - mouse_pos
	#
	#var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	#var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	#
	#var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	#var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
#
	#card_texture.material.set_shader_parameter("x_rot", rot_y)
	#card_texture.material.set_shader_parameter("y_rot", rot_x)

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)


func _on_mouse_exited() -> void:
	# 重置旋转
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)

	if not following_mouse:
		# 重置缩放
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)


func _on_pressed() -> void:
	if state_machine.current_state == State.INSHOP: # 只有在商店状态时才允许申请购买
		apply_to_purchase.emit(self)


