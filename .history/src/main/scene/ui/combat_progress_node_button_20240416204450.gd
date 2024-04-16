class_name CombatProgressNodeButton
extends TextureButton


var combat_node: CombatProgressGenerator.CombatNode = CombatProgressGenerator.CombatNode.new()
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var materialTemp = material.duplicate()

func _ready() -> void:
	self.material = materialTemp
	disabled = not combat_node.activate
	_update_visual()
	combat_node.connect("activate_changed", _on_activate_changed)
	combat_node.connect("selected_changed", _on_selected_changed)
	match combat_node.type:
		CombatProgressGenerator.NodeType.START:
			disabled = true
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/264.png")
		CombatProgressGenerator.NodeType.END: 
			disabled = true
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/162.png")
		CombatProgressGenerator.NodeType.NORMAL: 
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/137.png")
		CombatProgressGenerator.NodeType.ELITE:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/163.png")
		CombatProgressGenerator.NodeType.MYSTERY:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/232.png")
		CombatProgressGenerator.NodeType.TREASURE:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/107.png")

func _update_visual() -> void:
	'''
	更新按钮的视觉效果
	'''
	if disabled:
		button_pressed = false
		self.material.set_shader_parameter("line_color", Color(1,1,1,0))
	else:
		if button_pressed:
			self.material.set_shader_parameter("line_color", Color(1,0,0,1))
		else:
			self.material.set_shader_parameter("line_color", Color(1,1,1,1))

func _on_activate_changed(activate: bool) -> void:
	# print(Engine.get_physics_frames(), "  activate changed to: ", activate)
	disabled = not activate
	_update_visual()

func _on_selected_changed(selected: bool) -> void:
	# print(Engine.get_physics_frames(), "  selected changed to: ", selected)
	button_pressed = selected
	_update_visual()
	
func _on_toggled(toggled_on: bool) -> void:
	# print(Engine.get_physics_frames(), "  toggled changed to: ", toggled_on)
	CombatRouteManager.update(combat_node, toggled_on)

func _on_mouse_entered() -> void:
	if not disabled:
		animation_player.play("mouse_enter")

func _on_mouse_exited() -> void:
	if not disabled:
		animation_player.play("mouse_exit")

func _on_button_down() -> void:
	animation_player.play("pressed")
