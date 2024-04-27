extends RayCast2D

@onready var laser: Laser = $"."
@onready var line_2d: Line2D = $Line2D
@onready var attack_wait_timer: Timer = $AttackWaitTimer

signal hit(hurtbox)
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var damage: float
var target: CharacterBody2D = null
var knockback: float
var targetInitialPos: Vector2 = Vector2()
var attack_speed: float
var attack_wait_time: float = 1
var tween = create_tween() 


var is_casting: bool = false:
	set(v):
		is_casting = v
		if is_casting:
			appear()
		else:
			disappear()
		set_physics_process(v)


func _ready() -> void:
	attack_wait_time = attack_wait_time / attack_speed
	attack_wait_timer.wait_time = attack_wait_time
	set_physics_process(false)
	line_2d.points[0] = laser.position
	if target:
		is_casting = true

func _physics_process(delta: float) -> void:
	if not target:
		is_casting = false
		line_2d.points[0] = laser.position
	else :
		laser.target_position = to_local(target.position)
		force_raycast_update()
		if is_colliding():
			line_2d.points[1] = to_local(get_collision_point())
			if attack_wait_timer.is_stopped():
				hit.emit(get_collider())
				get_collider().hurt.emit(self)
				attack_wait_timer.start()
	


func appear() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(line_2d, "width", 5.0, 0.2)


func disappear() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(line_2d, "width", 0.0, 0.1)
