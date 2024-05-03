class_name WeaponStats
extends Node

var abc : Attribute_Changed
@export var origins: Array[Attribute_Changed.Origins]
@export var classes: Array[Attribute_Changed.Classes]

@onready var cost: float = 1
@onready var tier: float = 1:
	set(v):
		tier = v
		base_health *= 1.5
		base_health_regeneration *= 1.5
		base_power_physical *= 1.5
		base_range_attack *= 1.2
		_on_attribute_changed()

signal update_attribute

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 固有属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var deceleration_time: float = 0  #减速时间
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_health: float = 20  #生命值
@export var base_health_regeneration: float = 1  #生命恢复
@export var base_power_physical: float = 2.0  #物理攻击力
@export var base_power_magic: float = 0.0   #魔法攻击力
@export var base_time_cooldown: float = 1  #攻击冷却
@export var base_radius_search: float = 100.0 #索敌范围
@export var base_range_attack: float = 1  #攻击范围
@export var base_range_explosion: = 30   #爆炸范围
@export var base_knockback: float = 30.0    #击退效果
@export var base_critical_hit_rate: float = 0.0  #暴击率
@export var base_critical_damage: float = 2.0    #暴击伤害
@export var base_number_of_projectiles: int = 1   #发射物数量
@export var base_magazine: = 0  #弹匣
@export var base_speed_fly: float = 200.0   #武器飞行速度
@export var base_speed_rotation: float = 360.0   #旋转速度
@export var base_penetration_rate: float = 0  #穿透率
@export var base_deceleration_rate: float = 0  #减速率
@export var base_freezing_rate: float = 0 #冰冻率
@export var base_life_steal: float = 0 #吸血
@export var base_poison_layers: float = 0 #中毒层数
@export var base_max_poison_layers: float = 0 #最大中毒层数
@export var base_number_of_lighting_chain: float = 0 #闪电链数目
@export var base_power_lighting_chain: float = 0 #闪电链伤害

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var health: float = base_health  #生命值
@onready var health_regeneration: float = base_health_regeneration  #生命恢复
@onready var power_physical: float = base_power_physical  #物理攻击力
@onready var power_magic: float = base_power_magic   #魔法攻击力
#var damage: float = power_physical + power_magic  #总攻击力
@onready var time_cooldown: float = base_time_cooldown:   #攻击冷却
	set(v):
		time_cooldown = v
		$"../TimerCoolDown".wait_time = time_cooldown
@onready var radius_search: float = base_radius_search:   #索敌范围
	set(v):
		radius_search = v
		$"../Graphics/SearchBox/CollisionShape2D".shape.radius = radius_search
@onready var range_attack: float = base_range_attack  #攻击范围
@onready var range_explosion: float = base_range_explosion  #爆炸范围
@onready var knockback: float = base_knockback  #击退效果
@onready var critical_hit_rate: float = base_critical_hit_rate #暴击率
@onready var critical_damage: float = base_critical_damage #暴击伤害
@onready var number_of_projectiles: int = base_number_of_projectiles #发射物数量
@onready var speed_fly: float = base_speed_fly  #武器飞行速度
@onready var speed_rotation: float = base_speed_rotation  #旋转速度
@onready var penetration_rate: float = base_penetration_rate  #穿透率
@onready var magazine: float  = base_magazine  #弹匣
@onready var deceleration_rate: float = base_deceleration_rate  #减速率
@onready var freezing_rate: float = base_freezing_rate  #冰冻率
@onready var life_steal: float = base_life_steal  #吸血
@onready var poison_layers:float = base_poison_layers  #中毒层数
@onready var max_poison_layers:float = base_max_poison_layers  #最大中毒层数
@onready var number_of_lighting_chain:float = base_number_of_lighting_chain  #闪电链数目
@onready var power_lighting_chain:float = base_power_lighting_chain  #闪电链伤害


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _ready() -> void:
	await owner.ready
	abc = owner.player.abc
	_on_attribute_changed()
	abc.connect("attribute_changed",_on_attribute_changed)
	

func _on_attribute_changed():
	# >>>>>>>>>>>>>>>>>>>>> 生命相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_health = 0
	var classes_health = 0
	for _origin in origins:
		origins_health += abc.origins_attributes[_origin] [abc.Attributes.HEALTH]
	for _class in classes:
		classes_health += abc.classes_attributes[_class] [abc.Attributes.HEALTH]
	health = base_health * (1 + abc.player_attributes[abc.Attributes.HEALTH] + origins_health + classes_health)
	# >>>>>>>>>>>>>>>>>>>>> 生命恢复相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_health_regeneration = 0
	var classes_health_regeneration = 0
	for _origin in origins:
		origins_health_regeneration += abc.origins_attributes[_origin] [abc.Attributes.HEALTH_REGENERATION]
	for _class in classes:
		classes_health_regeneration += abc.classes_attributes[_class] [abc.Attributes.HEALTH_REGENERATION]
	health_regeneration = base_health_regeneration * (1 + abc.player_attributes[abc.Attributes.HEALTH_REGENERATION] + origins_health_regeneration + classes_health_regeneration)
	# >>>>>>>>>>>>>>>>>>>>> 物理伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_power_physical = 0
	var classes_power_physical = 0
	for _origin in origins:
		origins_power_physical += abc.origins_attributes[_origin] [abc.Attributes.POWER_PHYSICAL]
	for _class in classes:
		classes_power_physical += abc.classes_attributes[_class] [abc.Attributes.POWER_PHYSICAL]
	power_physical = base_power_physical * (1 + abc.player_attributes[abc.Attributes.POWER_PHYSICAL] + origins_power_physical + classes_power_physical)
	# >>>>>>>>>>>>>>>>>>>>> 魔法伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_power_magic = 0
	var classes_power_magic = 0
	for _origin in origins:
		origins_power_magic += abc.origins_attributes[_origin] [abc.Attributes.POWER_MAGIC]
	for _class in classes:
		classes_power_magic += abc.classes_attributes[_class] [abc.Attributes.POWER_MAGIC]
	power_magic = base_power_magic * (1 + abc.player_attributes[abc.Attributes.POWER_MAGIC] + origins_power_magic + classes_power_magic)
	# >>>>>>>>>>>>>>>>>>>>> 攻击冷却相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_time_cooldown = 0
	var classes_time_cooldown = 0
	for _origin in origins:
		origins_time_cooldown += abc.origins_attributes[_origin] [abc.Attributes.TIME_COOLDOWN]
	for _class in classes:
		classes_time_cooldown += abc.classes_attributes[_class] [abc.Attributes.TIME_COOLDOWN]
	time_cooldown = base_time_cooldown / (1 + abc.player_attributes[abc.Attributes.TIME_COOLDOWN] + origins_time_cooldown + classes_time_cooldown)
	# >>>>>>>>>>>>>>>>>>>>> 索敌范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_radius_search = 0
	var classes_radius_search = 0
	for _origin in origins:
		origins_radius_search += abc.origins_attributes[_origin] [abc.Attributes.RADIUS_SEARCH]
	for _class in classes:
		classes_radius_search += abc.classes_attributes[_class] [abc.Attributes.RADIUS_SEARCH]
	radius_search = base_radius_search * (1 + abc.player_attributes[abc.Attributes.RADIUS_SEARCH] + origins_radius_search + classes_radius_search)
	# >>>>>>>>>>>>>>>>>>>>> 攻击范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_range_attack = 0
	var classes_range_attack = 0
	for _origin in origins:
		origins_range_attack += abc.origins_attributes[_origin] [abc.Attributes.RANGE_ATTACK]
	for _class in classes:
		classes_range_attack += abc.classes_attributes[_class] [abc.Attributes.RANGE_ATTACK]
	range_attack = base_range_attack * (1 + abc.player_attributes[abc.Attributes.RANGE_ATTACK] + origins_range_attack + classes_range_attack)
	range_explosion = base_range_explosion + (1 + abc.player_attributes[abc.Attributes.RANGE_ATTACK] + origins_range_attack + classes_range_attack)
	# >>>>>>>>>>>>>>>>>>>>> 击退相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_knockback = 0
	var classes_knockback = 0
	for _origin in origins:
		origins_knockback += abc.origins_attributes[_origin] [abc.Attributes.KNOCKBACK]
	for _class in classes:
		classes_knockback += abc.classes_attributes[_class] [abc.Attributes.KNOCKBACK]
	knockback = base_knockback * (1 + abc.player_attributes[abc.Attributes.KNOCKBACK] + origins_knockback + classes_knockback)
	# >>>>>>>>>>>>>>>>>>>>> 暴击几率相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_critical_hit_rate = 0
	var classes_critical_hit_rate = 0
	for _origin in origins:
		origins_critical_hit_rate += abc.origins_attributes[_origin] [abc.Attributes.CRITICAL_HIT_RATE]
	for _class in classes:
		classes_critical_hit_rate += abc.classes_attributes[_class] [abc.Attributes.CRITICAL_HIT_RATE]
	critical_hit_rate = base_critical_hit_rate + (abc.player_attributes[abc.Attributes.CRITICAL_HIT_RATE] + origins_critical_hit_rate + classes_critical_hit_rate)
	# >>>>>>>>>>>>>>>>>>>>> 暴击伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_critical_damage = 0
	var classes_critical_damage = 0
	for _origin in origins:
		origins_critical_damage += abc.origins_attributes[_origin] [abc.Attributes.CRITICAL_DAMAGE]
	for _class in classes:
		classes_critical_damage += abc.classes_attributes[_class] [abc.Attributes.CRITICAL_DAMAGE]
	critical_damage = base_critical_damage + (abc.player_attributes[abc.Attributes.CRITICAL_DAMAGE] + origins_critical_damage + classes_critical_damage)
	# >>>>>>>>>>>>>>>>>>>>> 子弹数目相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_number_of_projectiles = 0
	var classes_number_of_projectiles = 0
	for _origin in origins:
		origins_number_of_projectiles += abc.origins_attributes[_origin] [abc.Attributes.NUMBER_OF_PROJECTILES]
	for _class in classes:
		classes_number_of_projectiles += abc.classes_attributes[_class] [abc.Attributes.NUMBER_OF_PROJECTILES]
	number_of_projectiles = base_number_of_projectiles + (abc.player_attributes[abc.Attributes.NUMBER_OF_PROJECTILES] + origins_number_of_projectiles + classes_number_of_projectiles)
	magazine = base_magazine + (abc.player_attributes[abc.Attributes.NUMBER_OF_PROJECTILES] + origins_number_of_projectiles + classes_number_of_projectiles)
	# >>>>>>>>>>>>>>>>>>>>> 飞行速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_speed_fly = 0
	var classes_speed_fly = 0
	for _origin in origins:
		origins_speed_fly += abc.origins_attributes[_origin] [abc.Attributes.SPEED_FLY]
	for _class in classes:
		classes_speed_fly += abc.classes_attributes[_class] [abc.Attributes.SPEED_FLY]
	speed_fly += base_speed_fly * (1 + abc.player_attributes[abc.Attributes.SPEED_FLY] + origins_speed_fly + classes_speed_fly)
	speed_rotation = base_speed_rotation * (1 + abc.player_attributes[abc.Attributes.SPEED_FLY] + origins_speed_fly + classes_speed_fly)
	# >>>>>>>>>>>>>>>>>>>>> 穿透率相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_penetration_rate = 0
	var classes_penetration_rate = 0
	for _origin in origins:
		origins_penetration_rate += abc.origins_attributes[_origin] [abc.Attributes.PENETRATION_RATE]
	for _class in classes:
		classes_penetration_rate += abc.classes_attributes[_class] [abc.Attributes.PENETRATION_RATE]
	penetration_rate = base_penetration_rate + (abc.player_attributes[abc.Attributes.PENETRATION_RATE] + origins_penetration_rate + classes_penetration_rate)
	# >>>>>>>>>>>>>>>>>>>>> 减速率相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_deceleration_rate = 0
	var classes_deceleration_rate = 0
	for _origin in origins:
		origins_deceleration_rate += abc.origins_attributes[_origin] [abc.Attributes.DECELERATION_RATE]
	for _class in classes:
		classes_deceleration_rate += abc.classes_attributes[_class] [abc.Attributes.DECELERATION_RATE]
	deceleration_rate = base_deceleration_rate + (abc.player_attributes[abc.Attributes.DECELERATION_RATE] + origins_deceleration_rate + classes_deceleration_rate)
	# >>>>>>>>>>>>>>>>>>>>> 冰冻率相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_freezing_rate = 0
	var classes_freezing_rate = 0
	for _origin in origins:
		origins_freezing_rate += abc.origins_attributes[_origin] [abc.Attributes.FREEZING_RATE]
	for _class in classes:
		classes_freezing_rate += abc.classes_attributes[_class] [abc.Attributes.FREEZING_RATE]
	freezing_rate = base_freezing_rate + (abc.player_attributes[abc.Attributes.FREEZING_RATE] + origins_freezing_rate + classes_freezing_rate)
	# >>>>>>>>>>>>>>>>>>>>> 吸血相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_life_steal = 0
	var classes_life_steal = 0
	for _origin in origins:
		origins_life_steal += abc.origins_attributes[_origin] [abc.Attributes.LIFE_STEAL]
	for _class in classes:
		classes_life_steal += abc.classes_attributes[_class] [abc.Attributes.LIFE_STEAL]
	life_steal = base_freezing_rate + (abc.player_attributes[abc.Attributes.LIFE_STEAL] + origins_freezing_rate + classes_life_steal)
	# >>>>>>>>>>>>>>>>>>>>> 中毒层数相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_poison_layers = 0
	var classes_poison_layers = 0
	for _origin in origins:
		origins_poison_layers += abc.origins_attributes[_origin] [abc.Attributes.POISON_LAYERS]
	for _class in classes:
		classes_poison_layers += abc.classes_attributes[_class] [abc.Attributes.POISON_LAYERS]
	poison_layers = base_poison_layers + (abc.player_attributes[abc.Attributes.POISON_LAYERS] + origins_poison_layers + classes_poison_layers)
	# >>>>>>>>>>>>>>>>>>>>> 最大中毒层数相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_max_poison_layers = 0
	var classes_max_poison_layers = 0
	for _origin in origins:
		origins_max_poison_layers += abc.origins_attributes[_origin] [abc.Attributes.MAX_POISON_LAYERS]
	for _class in classes:
		classes_max_poison_layers += abc.classes_attributes[_class] [abc.Attributes.MAX_POISON_LAYERS]
	max_poison_layers = base_max_poison_layers + (abc.player_attributes[abc.Attributes.MAX_POISON_LAYERS] + origins_max_poison_layers + classes_max_poison_layers)
	# >>>>>>>>>>>>>>>>>>>>> 闪电链数目相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_number_of_lighting_chain = 0
	var classes_number_of_lighting_chain = 0
	for _origin in origins:
		origins_number_of_lighting_chain += abc.origins_attributes[_origin] [abc.Attributes.NUMBER_OF_LIGHTING_CHAIN]
	for _class in classes:
		classes_number_of_lighting_chain += abc.classes_attributes[_class] [abc.Attributes.NUMBER_OF_LIGHTING_CHAIN]
	number_of_lighting_chain = base_number_of_lighting_chain + (abc.player_attributes[abc.Attributes.NUMBER_OF_LIGHTING_CHAIN] + origins_number_of_lighting_chain + classes_number_of_lighting_chain)
	# >>>>>>>>>>>>>>>>>>>>> 闪电链伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
	var origins_power_lighting_chain = 0
	var classes_power_lighting_chain = 0
	for _origin in origins:
		origins_power_lighting_chain += abc.origins_attributes[_origin] [abc.Attributes.POWER_LIGHTING_CHAIN]
	for _class in classes:
		classes_power_lighting_chain += abc.classes_attributes[_class] [abc.Attributes.POWER_LIGHTING_CHAIN]
	power_lighting_chain = base_power_lighting_chain + (abc.player_attributes[abc.Attributes.POWER_LIGHTING_CHAIN] + origins_power_lighting_chain + classes_power_lighting_chain)



	update_attribute.emit() # 属性更新信号，用于通知当前武器内部的其他节点更新属性
