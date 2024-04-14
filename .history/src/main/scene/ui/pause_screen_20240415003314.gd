extends Control

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var back_pack_animated_sprite_2d: AnimatedSprite2D = $BackPackAnimatedSprite2D
@onready var tabs_animated_sprite_2d: AnimatedSprite2D = $TabsAnimatedSprite2D
@onready var panels_animated_sprite_2d: AnimatedSprite2D = $PanelsAnimatedSprite2D


var up: bool = false
var down: bool = false

func _input(event):
	if not animation_playing():
		if event.is_action_pressed("move_up"):
			up = true
		if event.is_action_pressed("move_down"):
			down = true
	


func animation_playing() -> bool:
	return back_pack_animated_sprite_2d.is_playing() or tabs_animated_sprite_2d.is_playing() or panels_animated_sprite_2d.is_playing()


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	IDLE,
	INVENTORY,
	INVENTORY_LEAVE,
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
		State.IDLE:
			pass
		State.INVENTORY:
			pass
        State.INVENTORY_LEAVE:
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
		State.IDLE:
			if not animation_playing():
				return State.INVENTORY
		State.INVENTORY:
			if down and not animation_playing():
				return State.INVENTORY_LEAVE
        State.INVENTORY_LEAVE:
            if down and not animation_playing():
                down = false
                return State.COMBAT_PROGRESS
		State.COMBAT_PROGRESS:
			if up or down and not animation_playing():
				return State.COMBAT_PROGRESS_LEAVE
        State.COMBAT_PROGRESS_LEAVE:
            if down and not animation_playing():
                down = false
                return State.EQUIPMENT
		State.EQUIPMENT:
			if up and not animation_playing():
				return State.COMBAT_PROGRESS
			if down and not animation_playing():
				return State.QUESTS
		State.QUESTS:
			if up and not animation_playing():
				return State.EQUIPMENT
			if down and not animation_playing():
				return State.SAVE_LOAD
		State.SAVE_LOAD:
			if up and not animation_playing():
				return State.QUESTS
			if down and not animation_playing():
				return State.SETTINGS
		State.SETTINGS:
			if up and not animation_playing():
				return State.SAVE_LOAD

	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	
	match from:
		State.IDLE:
			#tabs_animated_sprite_2d.position.y += 10
			pass

	match to:
		State.IDLE:
			#tabs_animated_sprite_2d.position.y -= 10
			back_pack_animated_sprite_2d.play("Idle")
			#tabs_animated_sprite_2d.play("TabsAppear")
		State.INVENTORY:
			back_pack_animated_sprite_2d.play("InventoryAppear")
			tabs_animated_sprite_2d.play("SelectInventory")
		State.COMBAT_PROGRESS:
			back_pack_animated_sprite_2d.play("SelectCombatProgress")
			tabs_animated_sprite_2d.play("SelectCombatProgress")
			panels_animated_sprite_2d.play("CombatProgressAppear")
		State.EQUIPMENT:
			back_pack_animated_sprite_2d.play("SelectEquipment")
			tabs_animated_sprite_2d.play("SelectEquipment")
			panels_animated_sprite_2d.play("EquipmentAppear")
		State.QUESTS:
			back_pack_animated_sprite_2d.play("SelectQuests")
			tabs_animated_sprite_2d.play("SelectQuests")
			panels_animated_sprite_2d.play("QuestsAppear")
		State.SAVE_LOAD:
			back_pack_animated_sprite_2d.play("SelectSaveLoad")
			tabs_animated_sprite_2d.play("SelectSaveLoad")
			panels_animated_sprite_2d.play("SaveLoadAppear")
		State.SETTINGS:
			back_pack_animated_sprite_2d.play("SelectSettings")
			tabs_animated_sprite_2d.play("SelectSettings")
			panels_animated_sprite_2d.play("SettingsAppear")
