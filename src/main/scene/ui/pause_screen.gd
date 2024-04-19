extends Control

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var global_animation_player: AnimationPlayer = $GlobalAnimationPlayer
@onready var canvas_modulate: CanvasModulate = $CanvasModulate


signal show_equipment_screen(show: bool)

var first_tick: bool = true

var up: bool = false
var down: bool = false
var close_prepare_finished: bool = false
var show_flag: bool = false

func _ready() -> void:
	$StateMachine.owner = self
	$BackPackSprite2D.size = Vector2(384, 216)
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		show_flag = false
	if not animation_playing() and show_flag:
		if event.is_action_pressed("move_up"):
			up = true
		if event.is_action_pressed("move_down"):
			down = true	
	
func show_pause_screen() -> void:
	if not animation_playing():
		show_flag = true
		
func need_close_prepare() -> bool:
	if $BackPackSprite2D.scale != Vector2(1, 1):
		return true
	return false

func animation_playing() -> bool:
	return animation_player.is_playing()
		
func show_equip() -> void:
	show_equipment_screen.emit(true)
	
func hide_equip() -> void:
	show_equipment_screen.emit(false)
	
func start_pause() -> void:
	get_tree().paused = true
	
func cancel_pause() -> void:
	get_window().set_input_as_handled()
	get_tree().paused = false
	
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	CLOSE,
	OPEN,
	INVENTORY,
	INVENTORY_LEAVE,
	TOP_POUCH_OPEN,
	TOP_POUCH_CLOSE,
	COMBAT_PROGRESS,
	COMBAT_PROGRESS_LEAVE,
	EQUIPMENT,
	EQUIPMENT_LEAVE,
	QUESTS,
	QUESTS_LEAVE,
	SAVE_LOAD,
	SAVE_LOAD_LEAVE,
	SETTINGS,
	SETTINGS_LEAVE,
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.CLOSE:
			pass
		State.OPEN:
			pass
		State.INVENTORY:
			pass
		State.INVENTORY_LEAVE:
			pass
		State.TOP_POUCH_OPEN:
			pass
		State.TOP_POUCH_CLOSE:
			pass
		State.COMBAT_PROGRESS:
			pass
		State.COMBAT_PROGRESS_LEAVE:
			pass
		State.EQUIPMENT:
			pass
		State.EQUIPMENT_LEAVE:
			pass
		State.QUESTS:
			pass
		State.QUESTS_LEAVE:
			pass
		State.SAVE_LOAD:
			pass
		State.SAVE_LOAD_LEAVE:
			pass
		State.SETTINGS:
			pass
		State.SETTINGS_LEAVE:
			pass
			
func get_next_state(state: State) -> int:
	if not show_flag and state != State.OPEN:
		return StateMachine.KEEP_CURRENT if state == State.CLOSE else State.CLOSE
	match state:
		State.CLOSE:
			if show_flag and not animation_playing():
				return State.OPEN
		State.OPEN:
			if not animation_playing():
				return State.INVENTORY
		State.INVENTORY:
			if up:
				up = false
			if down and not animation_playing():
				return State.INVENTORY_LEAVE
		State.INVENTORY_LEAVE:
			if down and not animation_playing():
				down = false
				return State.TOP_POUCH_OPEN
		State.TOP_POUCH_OPEN:
			if not animation_playing():
				return State.COMBAT_PROGRESS
		State.TOP_POUCH_CLOSE:
			if not animation_playing():
				return State.INVENTORY
		State.COMBAT_PROGRESS:
			if (up or down) and not animation_playing():
				return State.COMBAT_PROGRESS_LEAVE
		State.COMBAT_PROGRESS_LEAVE:
			if up and not animation_playing():
				up = false
				return State.TOP_POUCH_CLOSE
			if down and not animation_playing():
				down = false
				return State.EQUIPMENT
		State.EQUIPMENT:
			if (up or down) and not animation_playing():
				return State.EQUIPMENT_LEAVE
		State.EQUIPMENT_LEAVE:
			if up and not animation_playing():
				up = false
				return State.COMBAT_PROGRESS
			if down and not animation_playing():
				down = false
				return State.QUESTS
		State.QUESTS:
			if (up or down) and not animation_playing():
				return State.QUESTS_LEAVE
		State.QUESTS_LEAVE:
			if up and not animation_playing():
				up = false
				return State.EQUIPMENT
			if down and not animation_playing():
				down = false
				return State.SAVE_LOAD
		State.SAVE_LOAD:
			if (up or down) and not animation_playing():
				return State.SAVE_LOAD_LEAVE
		State.SAVE_LOAD_LEAVE:
			if up and not animation_playing():
				up = false
				return State.QUESTS
			if down and not animation_playing():
				down = false
				return State.SETTINGS
		State.SETTINGS:
			if up and not animation_playing():
				return State.SETTINGS_LEAVE
		State.SETTINGS_LEAVE:
			if up and not animation_playing():
				up = false
				return State.SAVE_LOAD
			if down:
				down = false

	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.CLOSE:
			close_prepare_finished = false
			if need_close_prepare():
				animation_player.play("CloseWithPrepare")
			else:
				animation_player.play("Close")
			global_animation_player.play("leave_pause_screen")
			if first_tick:
				var animation_name = "Close"
				animation_player.play(animation_name)
				var animation_length = animation_player.get_animation(animation_name).length
				animation_player.seek(animation_length, true)
				first_tick = false
		State.OPEN:
			animation_player.play("Open")
			global_animation_player.play("enter_pause_screen")
		State.INVENTORY:
			animation_player.play("Inventory")
		State.INVENTORY_LEAVE:
			animation_player.play("InventoryDisappear")
		State.TOP_POUCH_OPEN:
			animation_player.play("TopPouchOpenT")
		State.TOP_POUCH_CLOSE:
			animation_player.play("TopPouchCloseT")
		State.COMBAT_PROGRESS:
			animation_player.play("CombatProgressAppear")
		State.COMBAT_PROGRESS_LEAVE:
			animation_player.play("CombatProgressDisappear")
		State.EQUIPMENT:
			animation_player.play("EquipmentAppear")
		State.EQUIPMENT_LEAVE:
			animation_player.play("EquipmentDisappear")
		State.QUESTS:
			animation_player.play("QuestsAppear")
		State.QUESTS_LEAVE:
			animation_player.play("QuestsDisappear")
		State.SAVE_LOAD:
			animation_player.play("SaveLoadAppear")
		State.SAVE_LOAD_LEAVE:
			animation_player.play("SaveLoadDisappear")
		State.SETTINGS:
			animation_player.play("SettingsAppear")
		State.SETTINGS_LEAVE:
			animation_player.play("SettingsDisappear")

