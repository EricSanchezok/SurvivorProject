extends Node2D

@onready var path_follow_2d_1: PathFollow2D = $Path2D_1/PathFollow2D
@onready var path_follow_2d_2: PathFollow2D = $Path2D_2/PathFollow2D
@onready var path_follow_2d_3: PathFollow2D = $Path2D_3/PathFollow2D
@onready var path_follow_2d_4: PathFollow2D = $Path2D_4/PathFollow2D
@onready var path_follow_2d_5: PathFollow2D = $Path2D_5/PathFollow2D

@onready var weapon_1: Node2D = $weapon_1
@onready var weapon_2: Node2D = $weapon_2
@onready var weapon_3: Node2D = $weapon_3
@onready var weapon_4: Node2D = $weapon_4
@onready var weapon_5: Node2D = $weapon_5
@onready var weapon_6: Node2D = $weapon_6
@onready var weapon_7: Node2D = $weapon_7
@onready var weapon_8: Node2D = $weapon_8
@onready var weapon_9: Node2D = $weapon_9
@onready var weapon_10: Node2D = $weapon_10

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var weapon_radius: float = 30.0
@export var angular_velocity: float = 30.0
@export var weapon_offsetY: float = -1

@onready var initial_angles = {
	weapon_6: 0.0,
	weapon_7: 72.0,
	weapon_8: 144.0,
	weapon_9: 216.0,
	weapon_10: 288.0
}

func _ready() -> void:
	animation_player.play("idle")
	# 设置外围武器的初始位置
	for weapon in [weapon_6, weapon_7, weapon_8, weapon_9, weapon_10]:
		var angle = deg_to_rad(initial_angles[weapon])
		weapon.position = Vector2(cos(angle), sin(angle)) * weapon_radius + Vector2(0, weapon_offsetY)

func _physics_process(delta: float) -> void:
	# 更新外围武器的位置使其围绕中心旋转
	for weapon in [weapon_6, weapon_7, weapon_8, weapon_9, weapon_10]:
		var current_angle = (weapon.position - Vector2(0, weapon_offsetY)).angle() + deg_to_rad(angular_velocity * delta)
		weapon.position = Vector2(cos(current_angle), sin(current_angle)) * weapon_radius + Vector2(0, weapon_offsetY)

func get_weapon_slot_instance(weapon_slot: int) -> Node2D:
	'''
	获取指定槽位的武器节点

	:param weapon_slot: 武器槽位
	:return: 武器节点
	'''
	match weapon_slot:
		1:
			return weapon_1
		2:
			return weapon_2
		3:
			return weapon_3
		4:
			return weapon_4
		5:
			return weapon_5
		6:
			return weapon_6
		7:
			return weapon_7
		8:
			return weapon_8
		9:
			return weapon_9
		10:
			return weapon_10
		_:
			return null


