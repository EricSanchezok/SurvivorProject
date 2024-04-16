extends TextureButton


var node_type: int
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	match node_type:
		CombatProgressGenerator.NodeType.START:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/137.png")
		CombatProgressGenerator.NodeType.END: 
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/137.png")
		CombatProgressGenerator.NodeType.NORMAL: 
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/137.png")
		CombatProgressGenerator.NodeType.ELITE:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/137.png")
		CombatProgressGenerator.NodeType.MYSTERY:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/137.png")
		CombatProgressGenerator.NodeType.TREASURE:
			texture_normal = load("res://src/main/assets/packs/Fantasy RPG icon pack (by Franuka)/Individual icons (32x32)/137.png")


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		material.set_shader_parameter("line_color", Color(1,1,1,1))
	else:
		material.set_shader_parameter("line_color", Color(1,1,1,0))

#
#func _on_mouse_entered() -> void:
	#animation_player.play("mouse_enter")
#
#
#func _on_mouse_exited() -> void:
	#animation_player.play("mouse_exit")


func _on_button_down() -> void:
	animation_player.play("pressed")
