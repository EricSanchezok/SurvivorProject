class_name ProjectileBase
extends CharacterBody2D

@export var tracking: bool = false
@export var bezier: bool = false
@export var bezier_param: float = 1.0
@export var in_front: bool = false
@export var in_front_dis: int = 5

var parent_weapon: WeaponBase
var target: EnemyBase
var target_position: Vector2

var power_physical: float #物理攻击力
var power_magic: float #魔法攻击力
var range_explosion: float #爆炸范围
var knockback: float #击退效果
var critical_hit_rate: float #暴击率
var critical_damage: float #暴击伤害
var speed_fly: float #武器飞行速度
var penetration_rate: float #穿透率

var deceleration_rate: float #减速率
var deceleration_time: float #减速时间
var freezing_rate: float #冰冻率
var life_steal: float #吸血

var acceleration: float = 0.0
var deceleration: float = 0.0

var current_time: float = 0.0

signal reach_target
var reached: bool = false
var stop_moveing: bool = false

func _ready() -> void:
	if target == null:
		target = parent_weapon.target
	
	power_physical = parent_weapon.power_physical
	power_magic = parent_weapon.power_magic
	range_explosion = parent_weapon.range_explosion
	knockback = parent_weapon.knockback
	critical_hit_rate = parent_weapon.critical_hit_rate
	critical_damage = parent_weapon.critical_damage
	speed_fly = parent_weapon.speed_fly
	penetration_rate = parent_weapon.penetration_rate
	
	deceleration_rate = parent_weapon.deceleration_rate
	deceleration_time = parent_weapon.deceleration_time
	freezing_rate = parent_weapon.freezing_rate
	life_steal = parent_weapon.life_steal

func _physics_process(delta: float) -> void:
	if stop_moveing:
		return
	speed_fly = speed_fly + acceleration * delta - deceleration * delta
	if tracking:
		if not in_front:
			target_position = target.global_position
		else:
			var dir_to_parent = (parent_weapon.global_position - target.global_position).normalized()
			target_position = target.global_position + in_front_dis * dir_to_parent
		if bezier:
			current_time += delta
			var distance = position.distance_to(target_position)
			var total_time = distance / speed_fly
			var t = min(current_time/total_time, 1)
			var start_control_point = position + Vector2(cos(rotation), sin(rotation)) * speed_fly * bezier_param
			var next_point = position.bezier_interpolate(start_control_point, target_position, target_position, t)
			look_at(next_point)
			position = position.move_toward(next_point, speed_fly * delta)
		else:
			look_at(target_position)
			position = position.move_toward(target_position, speed_fly * delta)
	else:
		look_at(target_position)
		position = position.move_toward(target_position, speed_fly * delta)
		
	if position.distance_squared_to(target_position) < pow(1, 2) and not reached:
		reached = true
		reach_target.emit()

func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
		queue_free()

func _on_destroy_timer_timeout() -> void:
	queue_free()
	

