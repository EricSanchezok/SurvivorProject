class_name WeaponBase
extends CharacterBody2D

var enemies: Array = []
var slot: Marker2D
var player: CharacterBody2D
var player_stats: Node

@onready var timer_cool_down: Timer = $TimerCoolDown
@onready var searching_shape_2d: CollisionShape2D = $SearchBox/CollisionShape2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_power_physical: float = 4.0  #物理攻击力
@export var base_power_magic: float = 2.0   #魔法攻击力
@export var base_time_cooldown: float = 1  #攻击冷却
@export var base_speed_rotation: float = 15.0   #旋转速度
@export var base_range_attack: float = 150.0 #攻击范围
@export var base_range_explosion: = 50   #爆炸范围
@export var base_knockback: float = 30.0    #击退效果
@export var base_critical_hit_rate: float = 0.0  #暴击率
@export var base_critical_damage: float = 0.0    #暴击伤害
@export var base_number_of_projectiles: int = 1   #发射物数量
@export var base_speed_fly: float = 200.0   #武器飞行速度
@export var base_penetration_rate: = 0  #穿透率
@export var base_magazine: = 0  #弹匣

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var power_physical: float = base_power_physical #物理攻击力
var power_magic: float = base_power_magic #魔法攻击力
var damage: float = power_physical + power_magic #总攻击力
var time_cooldown: float = base_time_cooldown   #攻击冷却
var speed_rotation: float = base_speed_rotation  #旋转速度
var range_attack: float = base_range_attack  #攻击范围
var range_explosion: float = base_range_explosion  #爆炸范围
var knockback: float = base_knockback  #击退效果
var critical_hit_rate: float = base_critical_hit_rate #暴击率
var critical_damage: float = base_critical_damage #暴击伤害
var number_of_projectiles: int = base_number_of_projectiles #发射物数量
var speed_fly: float = base_speed_fly  #武器飞行速度
var penetration_rate: float = base_penetration_rate  #穿透率
var magazine: float  = base_magazine  #弹匣
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func modify_attribute(attribute_name: String, change_type: String, value : float):
	# 使用match语句选择属性和修改类型
	match attribute_name:
# >>>>>>>>>>>>>>>>>>>>> 物理伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"power_physical":
			match change_type:
				"percent":
					power_physical += base_power_physical * value  
					damage =  power_physical + power_magic
				"absolute":
					power_physical += value
					damage =  power_physical + power_magic
# >>>>>>>>>>>>>>>>>>>>> 魔法伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"power_magic":
			match change_type:
				"percent":
					power_magic += base_power_magic * value
					damage =  power_physical + power_magic
				"absolute":
					power_magic += value
					damage =  power_physical + power_magic
# >>>>>>>>>>>>>>>>>>>>> 攻击冷却相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"time_cooldown":
			match change_type:
				"percent":
					if value == 0:
						return
					time_cooldown += base_time_cooldown / value
					timer_cool_down.wait_time = time_cooldown
					speed_rotation += base_speed_rotation * value
				"absolute":
					time_cooldown += value
					timer_cool_down.wait_time = time_cooldown
# >>>>>>>>>>>>>>>>>>>>> 攻击范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"base_range_attack":
			match change_type:
				"percent":
					range_attack += base_range_attack * value
					searching_shape_2d.shape.radius = range_attack
					range_explosion += base_range_explosion * value
				"absolute":
					range_attack += value
					searching_shape_2d.shape.radius = range_attack
					range_explosion += value
# >>>>>>>>>>>>>>>>>>>>> 击退相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"knockback":
			match change_type:
				"percent":
					knockback += base_knockback * value
				"absolute":
					knockback += value
# >>>>>>>>>>>>>>>>>>>>> 暴击几率相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"critical_hit_rate":
			match change_type:
				"percent":
					critical_hit_rate += base_critical_hit_rate * value
				"absolute":
					critical_hit_rate += value
# >>>>>>>>>>>>>>>>>>>>> 暴击伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"critical_damage":
			match change_type:
				"percent":
					critical_damage += base_critical_damage * value
				"absolute":
					critical_damage += value
# >>>>>>>>>>>>>>>>>>>>> 子弹数目相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"number_of_projectiles":
			match change_type:
				"percent":
					number_of_projectiles += base_number_of_projectiles * value
					magazine += base_magazine * value
				"absolute":
					number_of_projectiles += value
					magazine += value
# >>>>>>>>>>>>>>>>>>>>> 飞行速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"speed_fly":
			match change_type:
				"percent":
					speed_fly += base_speed_fly * value
				"absolute":
					speed_fly += value
# >>>>>>>>>>>>>>>>>>>>> 穿透率相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"penetration_rate":
			match change_type:
				"percent":
					penetration_rate += base_penetration_rate * value
				"absolute":
					penetration_rate += value



@export var search_radius: float = 100.0:
	set(v):
		search_radius = v
		$SearchBox/CollisionShape2D.shape.radius = search_radius
		
#@export var time_cooldown: float = 1.0:
	#set(v):
		#time_cooldown = v
		#$TimerCoolDown.wait_time = time_cooldown
		
func get_nearest_enemy() -> CharacterBody2D:
	'''
	获取最近的敌人
	
	:return: 最近的敌人
	'''
	var nearestEnemy: CharacterBody2D = null
	var nearestDistance: float = pow(search_radius, 2)
	for enemy in enemies:
		var distance = enemy.global_position.distance_squared_to(global_position)
		if distance < nearestDistance:
			nearestEnemy = enemy
			nearestDistance = distance
	return nearestEnemy
	
func get_random_enemy() -> CharacterBody2D:
	return enemies.pick_random()

func _on_search_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)

func _on_search_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)
