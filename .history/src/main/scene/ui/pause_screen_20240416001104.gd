extends Control

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var up: bool = false
var down: bool = false

func _input(event):
	if not animation_playing():
		if event.is_action_pressed("move_up"):
			up = true
		if event.is_action_pressed("move_down"):
			down = true
	
func animation_playing() -> bool:
	return animation_player.is_playing()

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
	## 打印视口中心点的坐标
	#var camera_2d = get_viewport().get_camera_2d()
	#print(camera_2d.get_screen_center_position())

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
	match state:
		State.CLOSE:
			pass
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
	print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 

	match to:
		State.CLOSE:
			pass
		State.OPEN:
			animation_player.play("Open")
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
