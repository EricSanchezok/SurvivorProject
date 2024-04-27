class_name WeaponBase
extends CharacterBody2D

var enemies: Array = []
var slot: Marker2D
var player: CharacterBody2D
var player_stats: Node 
var abc : Attribute_Changed
@export var origins: Array[Attribute_Changed.Origins]
@export var classes: Array[Attribute_Changed.Classes]

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_power_physical: float = 4.0 					#物理攻击力
@export var base_power_magic: float = 2.0   					#魔法攻击力
@export var base_time_cooldown: float = 1  						#攻击冷却
@export var base_radius_search: float = 150.0 					#攻击范围
@export var base_range_explosion: = 50   						#爆炸范围
@export var base_knockback: float = 30.0    					#击退效果
@export var base_critical_hit_rate: float = 0.0 	 			#暴击率
@export var base_critical_damage: float = 0.0    				#暴击伤害
@export var base_number_of_projectiles: int = 1   				#发射物数量
@export var base_magazine: = 0  								#弹匣
@export var base_speed_fly: float = 200.0   					#武器飞行速度
@export var base_speed_rotation: float = 15.0   				#旋转速度
@export var base_penetration_rate: float = 0  					#穿透率

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var power_physical: float = base_power_physical 				#物理攻击力
var power_magic: float = base_power_magic 						#魔法攻击力
var damage: float = power_physical + power_magic 				#总攻击力
var time_cooldown: float = base_time_cooldown:   				#攻击冷却
	set(v):
		time_cooldown = v
		$TimerCoolDown.wait_time = time_cooldown
var radius_search: float = base_radius_search:   				#攻击范围
	set(v):
		radius_search = v
		$SearchBox/CollisionShape2D.shape.radius = radius_search
var range_explosion: float = base_range_explosion  				#爆炸范围
var knockback: float = base_knockback  							#击退效果
var critical_hit_rate: float = base_critical_hit_rate 			#暴击率
var critical_damage: float = base_critical_damage 				#暴击伤害
var number_of_projectiles: int = base_number_of_projectiles 	#发射物数量
var speed_fly: float = base_speed_fly  							#武器飞行速度
var speed_rotation: float = base_speed_rotation  				#旋转速度
var penetration_rate: float = base_penetration_rate  			#穿透率
var magazine: float  = base_magazine  							#弹匣

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _ready() -> void:
	abc = player.abc
	_on_attribute_changed()
	abc.connect("attribute_changed",_on_attribute_changed)
	
func _on_stats_changed() -> void:
	_on_attribute_changed()

func _on_attribute_changed():
	# >>>>>>>>>>>>>>>>>>>>> 物理伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_power_physical = 0
	var classes_power_physical = 0
	for _origin in origins:
		origins_power_physical += abc.origins_attributes[_origin] [abc.Attributes.POWER_PHYSICAL]
	for _class in classes:
		classes_power_physical += abc.origins_attributes[_class] [abc.Attributes.POWER_PHYSICAL]
	power_physical += base_power_physical * (abc.player_attributes[abc.Attributes.POWER_PHYSICAL] + origins_power_physical + classes_power_physical)
	# >>>>>>>>>>>>>>>>>>>>> 魔法伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_power_magic = 0
	var classes_power_magic = 0
	for _origin in origins:
		origins_power_magic += abc.origins_attributes[_origin] [abc.Attributes.POWER_MAGIC]
	for _class in classes:
		classes_power_magic += abc.origins_attributes[_class] [abc.Attributes.POWER_MAGIC]
	power_magic += base_power_magic * (abc.player_attributes[abc.Attributes.POWER_MAGIC] + origins_power_magic + classes_power_magic)
	# >>>>>>>>>>>>>>>>>>>>> 攻击冷却相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_time_cooldown = 0
	var classes_time_cooldown = 0
	for _origin in origins:
		origins_time_cooldown += abc.origins_attributes[_origin] [abc.Attributes.TIME_COOLDOWN]
	for _class in classes:
		classes_time_cooldown += abc.origins_attributes[_class] [abc.Attributes.TIME_COOLDOWN]
	time_cooldown += base_time_cooldown * (abc.player_attributes[abc.Attributes.TIME_COOLDOWN] + origins_time_cooldown + classes_time_cooldown)
	# >>>>>>>>>>>>>>>>>>>>> 攻击范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_radius_search = 0
	var classes_radius_search = 0
	for _origin in origins:
		origins_radius_search += abc.origins_attributes[_origin] [abc.Attributes.RADIUS_SEARCH]
	for _class in classes:
		classes_radius_search += abc.origins_attributes[_class] [abc.Attributes.RADIUS_SEARCH]
	radius_search += base_radius_search * (abc.player_attributes[abc.Attributes.RADIUS_SEARCH] + origins_radius_search + classes_radius_search)
	range_explosion += base_range_explosion * (abc.player_attributes[abc.Attributes.RADIUS_SEARCH] + origins_radius_search + classes_radius_search)
	# >>>>>>>>>>>>>>>>>>>>> 击退相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_knockback = 0
	var classes_knockback = 0
	for _origin in origins:
		origins_knockback += abc.origins_attributes[_origin] [abc.Attributes.KNOCKBACK]
	for _class in classes:
		classes_knockback += abc.origins_attributes[_class] [abc.Attributes.KNOCKBACK]
	knockback += base_knockback * (abc.player_attributes[abc.Attributes.KNOCKBACK] + origins_knockback + classes_knockback)
	# >>>>>>>>>>>>>>>>>>>>> 暴击几率相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_critical_hit_rate = 0
	var classes_critical_hit_rate = 0
	for _origin in origins:
		origins_critical_hit_rate += abc.origins_attributes[_origin] [abc.Attributes.CRITICAL_HIT_RATE]
	for _class in classes:
		classes_critical_hit_rate += abc.origins_attributes[_class] [abc.Attributes.CRITICAL_HIT_RATE]
	critical_hit_rate += base_critical_hit_rate + (abc.player_attributes[abc.Attributes.CRITICAL_HIT_RATE] + origins_critical_hit_rate + classes_critical_hit_rate)
	# >>>>>>>>>>>>>>>>>>>>> 暴击伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_critical_damage = 0
	var classes_critical_damage = 0
	for _origin in origins:
		origins_critical_damage += abc.origins_attributes[_origin] [abc.Attributes.CRITICAL_DAMAGE]
	for _class in classes:
		classes_critical_damage += abc.origins_attributes[_class] [abc.Attributes.CRITICAL_DAMAGE]
	critical_damage += base_critical_damage + (abc.player_attributes[abc.Attributes.CRITICAL_DAMAGE] + origins_critical_damage + classes_critical_damage)
	# >>>>>>>>>>>>>>>>>>>>> 子弹数目相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_number_of_projectiles = 0
	var classes_number_of_projectiles = 0
	for _origin in origins:
		origins_number_of_projectiles += abc.origins_attributes[_origin] [abc.Attributes.NUMBER_OF_PROJECTILES]
	for _class in classes:
		classes_number_of_projectiles += abc.origins_attributes[_class] [abc.Attributes.NUMBER_OF_PROJECTILES]
	number_of_projectiles += base_number_of_projectiles + (abc.player_attributes[abc.Attributes.NUMBER_OF_PROJECTILES] + origins_number_of_projectiles + classes_number_of_projectiles)
	magazine += base_magazine + (abc.player_attributes[abc.Attributes.NUMBER_OF_PROJECTILES] + origins_number_of_projectiles + classes_number_of_projectiles)
	# >>>>>>>>>>>>>>>>>>>>> 飞行速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_speed_fly = 0
	var classes_speed_fly = 0
	for _origin in origins:
		origins_speed_fly += abc.origins_attributes[_origin] [abc.Attributes.SPEED_FLY]
	for _class in classes:
		classes_speed_fly += abc.origins_attributes[_class] [abc.Attributes.SPEED_FLY]
	speed_fly += base_speed_fly * (abc.player_attributes[abc.Attributes.SPEED_FLY] + origins_speed_fly + classes_speed_fly)
	speed_rotation += base_speed_rotation * (abc.player_attributes[abc.Attributes.SPEED_FLY] + origins_speed_fly + classes_speed_fly)
	# >>>>>>>>>>>>>>>>>>>>> 穿透率相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_penetration_rate = 0
	var classes_penetration_rate = 0
	for _origin in origins:
		origins_penetration_rate += abc.origins_attributes[_origin] [abc.Attributes.PENETRATION_RATE]
	for _class in classes:
		classes_penetration_rate += abc.origins_attributes[_class] [abc.Attributes.PENETRATION_RATE]
	penetration_rate += base_penetration_rate + (abc.player_attributes[abc.Attributes.PENETRATION_RATE] + origins_penetration_rate + classes_penetration_rate)


func get_nearest_enemy() -> CharacterBody2D:
	'''
	获取最近的敌人
	
	:return: 最近的敌人
	'''
	var nearestEnemy: CharacterBody2D = null
	var nearestDistance: float = pow(radius_search, 2)
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
