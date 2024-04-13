extends RayCast2D

@onready var line_2d: Line2D = $Line2D

func _physics_process(delta: float) -> void:
	var cast_point := target_position

	force_raycast_update()

	if is_colliding():
		cast_point = to_local(get_collision_point())

	
