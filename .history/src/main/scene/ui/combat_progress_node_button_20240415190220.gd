class_name CombatProgressNodeButton
extends TextureButton


var node_type: int = CombatProgressGenerator.NodeType.START
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var materialTemp = material.duplicate()

func _ready() -> void:
	self.material = materialTemp
	match node_type:
		CombatProgressGenerator.NodeType.START:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/264.png")
		CombatProgressGenerator.NodeType.END: 
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/162.png")
		CombatProgressGenerator.NodeType.NORMAL: 
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/137.png")
		CombatProgressGenerator.NodeType.ELITE:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/163.png")
		CombatProgressGenerator.NodeType.MYSTERY:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/232.png")
		CombatProgressGenerator.NodeType.TREASURE:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/107.png")


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# print(self, "  on")
		self.material.set_shader_parameter("line_color", Color(1,1,1,1))
	else:
		# print(self, "  off")
		self.material.set_shader_parameter("line_color", Color(1,1,1,0))


func _on_mouse_entered() -> void:
	animation_player.play("mouse_enter")

func _on_mouse_exited() -> void:
	animation_player.play("mouse_exit")


func _on_button_down() -> void:
	animation_player.play("pressed")