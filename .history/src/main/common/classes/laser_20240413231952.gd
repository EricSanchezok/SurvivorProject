extends RayCast2D

@onready var line_2d: Line2D = $Line2D

var is_casting := false setget set_is_casting



func _ready() -> void:
	set_physics_process(false)
	line_2d.points[1] = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var cast_point := target_position

	force_raycast_update()

	if is_colliding():
		cast_point = to_local(get_collision_point())

	line_2d.points[1] = cast_point


func set_is_casting(value: bool) -> void:
	is_casting = value
	if is_casting:
		start()
	else:
		stop()