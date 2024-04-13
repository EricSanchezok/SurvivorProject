extends RayCast2D

@onready var line_2d: Line2D = $Line2D

var is_casting := false setget set_is_casting

func _physics_process(delta: float) -> void:
	var cast_point := target_position

	force_raycast_update()

	if is_colliding():
		cast_point = to_local(get_collision_point())

	line_2d.points[1] = cast_point
