extends Button

@onready var card_texture: TextureRect = $CardTexture

var following_mouse: bool = false
var angle_x_max: float = deg_to_rad(45)
var angle_y_max: float = deg_to_rad(45)


func _gui_input(event: InputEvent) -> void:
	if following_mouse: return
	if not event is InputEventMouseMotion: return
	
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	var diff: Vector2 = (position + size) - mouse_pos
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(-angle_y_max, angle_y_max, lerp_val_y))

	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)
