class_name ProjectileBase
extends CharacterBody2D

@export var bezier_param: float = 1.0

var parent_weapon: WeaponBase
var target: EnemyBase
var tracking: bool = false
var bezier: bool = false

var power_physical: float #物理攻击力
var power_magic: float #魔法攻击力
var range_explosion: float #爆炸范围
var knockback: float #击退效果
var critical_hit_rate: float #暴击率
var critical_damage: float #暴击伤害
var speed_fly: float #武器飞行速度
var penetration_rate: float #穿透率

var acceleration: float = 0.0
var deceleration: float = 0.0

func _ready() -> void:
	target = parent_weapon.target
	
	power_physical = parent_weapon.power_physical
	power_magic = parent_weapon.power_magic
	range_explosion = parent_weapon.range_explosion
	knockback = parent_weapon.knockback
	critical_hit_rate = parent_weapon.critical_hit_rate
	critical_damage = parent_weapon.critical_damage
	speed_fly = parent_weapon.speed_fly
	penetration_rate = parent_weapon.penetration_rate
	


func _physics_process(delta: float) -> void:
	if tracking:
		if bezier:
			pass
		else:
			pass
	else:
		var direction = Vector2(cos(rotation), sin(rotation))
		velocity = direction * speed_fly
	
	move_and_collide(velocity*delta)
	


func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
		queue_free()

func _on_destroy_timer_timeout() -> void:
	queue_free()
