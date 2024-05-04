class_name ProjectileBase
extends CharacterBody2D
var initial_rotation: float

@export var tracking: bool = false
@export var bezier: bool = false
@export var bezier_param: float = 1.0
@export var in_front: bool = false
@export var in_front_dis: int = 5


var parent_weapon: WeaponBase
var parent_weapon_position: Vector2
var target: EnemyBase
var target_position: Vector2
var weapon_stats: WeaponStats = WeaponStats.new()
var kills: int:
	set(v):
		parent_weapon.kills += 1
		kills = v

var acceleration: float = 0.0
var deceleration: float = 0.0

signal reach_target
var reached: bool = false
var stop_moveing: bool = false
var current_time: float = 0.0


func _ready() -> void:
	if target == null:
		target = parent_weapon.target
	weapon_stats.sync_parameters(parent_weapon.weapon_stats)
	weapon_stats.knockback *= 3
	weapon_stats.speed_fly *= 2
	$Graphics.rotation = initial_rotation


func _physics_process(delta: float) -> void:
	if stop_moveing:
		return
	weapon_stats.speed_fly = weapon_stats.speed_fly + acceleration * delta - deceleration * delta
	if tracking:
		if is_instance_valid(target):
			if not target.is_dead:
				if not in_front:
					target_position = target.global_position
				else:
					if is_instance_valid(parent_weapon): parent_weapon_position = parent_weapon.global_position
					var dir_to_parent = (parent_weapon_position - target.global_position).normalized()
					target_position = target.global_position + in_front_dis * dir_to_parent
		if bezier:
			current_time += delta
			var distance = position.distance_to(target_position)
			var total_time = distance / weapon_stats.speed_fly
			var t = min(current_time/total_time, 1)
			var start_control_point = position + Vector2(cos($Graphics.rotation), sin($Graphics.rotation)) * weapon_stats.speed_fly * bezier_param
			var next_point = position.bezier_interpolate(start_control_point, target_position, target_position, t)
			$Graphics.look_at(next_point)
			position = position.move_toward(next_point, weapon_stats.speed_fly * delta)
		else:
			$Graphics.look_at(target_position)
			position = position.move_toward(target_position, weapon_stats.speed_fly * delta)
	else:
		$Graphics.look_at(target_position)
		position = position.move_toward(target_position, weapon_stats.speed_fly * delta)
		
		
	if position.distance_squared_to(target_position) < pow(3, 2) and not reached:
		reached = true
		reach_target.emit()
		
func trigger_hit_effect() -> void:
	pass
	
func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(weapon_stats.penetration_rate):
		print("消失： ", weapon_stats.penetration_rate)
		queue_free()

func _on_destroy_timer_timeout() -> void:
	queue_free()
	

	

