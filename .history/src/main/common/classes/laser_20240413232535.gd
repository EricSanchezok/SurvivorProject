extends RayCast2D

@onready var line_2d: Line2D = $Line2D

var tween = Tween.new()

var is_casting: bool = false:
	set(v):
		is_casting = v
		set_physics_process(v)

func _ready() -> void:
	set_physics_process(false)
	line_2d.points[1] = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var cast_point := target_position
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
	line_2d.points[1] = cast_point


func appear() -> void:
	tween.stop_all()
	tween.interpolate_property(self, "width", 0, 10.0, 0.2)
	tween.start()