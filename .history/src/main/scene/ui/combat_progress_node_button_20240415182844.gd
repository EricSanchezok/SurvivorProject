extends TextureButton


var node_type: int
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	match node_type:
		0:
			material.set_shader_parameter("line_color", Color(1,1,1,0))
		1:
			material.set_shader_parameter("line_color", Color(1,1,1,1))
		_:
			pass


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
