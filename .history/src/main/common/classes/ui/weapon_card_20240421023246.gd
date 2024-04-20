extends Button

var following_mouse: bool = false


func _gui_input(event: InputEvent) -> void:
	if following_mouse: return
	if not event is InputEventMouseMotion: return
	
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	var diff: Vector2 = (position + size) - mouse_pos
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	
