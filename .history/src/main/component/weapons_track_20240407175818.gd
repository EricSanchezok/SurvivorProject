extends Node2D




@onready var path_follow_2d_1: PathFollow2D = $Path2D_1/PathFollow2D
@onready var path_follow_2d_2: PathFollow2D = $Path2D_2/PathFollow2D
@onready var path_follow_2d_3: PathFollow2D = $Path2D_3/PathFollow2D
@onready var path_follow_2d_4: PathFollow2D = $Path2D_4/PathFollow2D
@onready var path_follow_2d_5: PathFollow2D = $Path2D_5/PathFollow2D

@onready var weapon_6: Node2D = $weapon_6
@onready var weapon_7: Node2D = $weapon_7
@onready var weapon_8: Node2D = $weapon_8
@onready var weapon_9: Node2D = $weapon_9


@export var weapon_radius: float = 50.0
@export var angular_velocity: float = 30.0


@onready var initial_angles = {
	weapon_6: 45.0,
	weapon_7: 135.0,
	weapon_8: 225.0,
	weapon_9: 315.0
}


func _ready() -> void:
	# 设置每个武器的初始位置
	for weapon in [weapon_6, weapon_7, weapon_8, weapon_9]:
		var angle = deg_to_rad(initial_angles[weapon])
		weapon.position = Vector2(cos(angle), sin(angle)) * weapon_radius

func _process(delta: float) -> void:
	# 更新每个武器的位置使其围绕中心旋转
	for weapon in [weapon_6, weapon_7, weapon_8, weapon_9]:
		var current_angle = weapon.position.angle() + deg_to_rad(angular_velocity * delta)
		weapon.position = Vector2(cos(current_angle), sin(current_angle)) * weapon_radius




