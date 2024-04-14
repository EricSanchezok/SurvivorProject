extends Control

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var back_pack_animated_sprite_2d: AnimatedSprite2D = $BackPackAnimatedSprite2D
@onready var tabs_animated_sprite_2d: AnimatedSprite2D = $TabsAnimatedSprite2D
@onready var panels_animated_sprite_2d: AnimatedSprite2D = $PanelsAnimatedSprite2D



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	IDLE,
	INVENTORY,
	COMBAT_PROGRESS,
	EQUIPMENT,
	QUESTS,
	SAVE_LOAD,
	SETTINGS
}

func animation_playing() -> bool:
	print(back_pack_animated_sprite_2d.is_playing())
	return back_pack_animated_sprite_2d.is_playing() or tabs_animated_sprite_2d.is_playing() or panels_animated_sprite_2d.is_playing()


func tick_physics(state: State, delta: float) -> void:
	## 打印视口中心点的坐标
	#var camera_2d = get_viewport().get_camera_2d()
	#print(camera_2d.get_screen_center_position())

	match state:
		State.IDLE:
			pass
		State.INVENTORY:
			pass
		State.COMBAT_PROGRESS:
			pass
		State.EQUIPMENT:
			pass
		State.QUESTS:
			pass
		State.SAVE_LOAD:
			pass
		State.SETTINGS:
			pass
			
func get_next_state(state: State) -> int:
	match state:
		State.IDLE:
			if not animation_playing():
				return State.INVENTORY
		State.INVENTORY:
			if input.is_action_just_pressed("ui_cancel"):
                return State.IDLE
		State.COMBAT_PROGRESS:
			pass
		State.EQUIPMENT:
			pass
		State.QUESTS:
			pass
		State.SAVE_LOAD:
			pass
		State.SETTINGS:
			pass

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
			pass
		State.EQUIPMENT:
			pass
		State.QUESTS:
			pass
		State.SAVE_LOAD:
			pass
		State.SETTINGS:
			pass
