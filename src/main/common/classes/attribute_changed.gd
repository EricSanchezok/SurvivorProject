class_name Attribute_Changed
extends Node

signal attribute_changed

# 定义origins和classes
enum Origins { FIRE, FROST, LIGHTING, EARTH, POISON, NATURE, HOLY, EVIL, PSYCHIC, TECH }

enum Classes { SWORD, SHIELD, AXE, SPEAR, HAMMER, DAGGER, ARMOR, RING, BOOMERANG, BOW, STAFF, WAND, SCROLL, GUN, TURRET, BOMB }


# 定义属性
enum Attributes {
	HEALTH,
	HEALTH_REGENERATION,
	POWER_PHYSICAL, 
	POWER_MAGIC,  
	TIME_COOLDOWN,  
	RADIUS_SEARCH, 
	RANGE_ATTACK,
	KNOCKBACK, 
	CRITICAL_HIT_RATE, 
	CRITICAL_DAMAGE, 
	NUMBER_OF_PROJECTILES,
	SPEED_FLY, 
	PENETRATION_RATE,
	DECELERATION_RATE,
	FREEZING_RATE,
	LIFE_STEAL,
	POISON_LAYERS,
	MAX_POISON_LAYERS,
	NUMBER_OF_LIGHTING_CHAIN,
	POWER_LIGHTING_CHAIN,
}



# 创建二维数组
var origins_attributes = Array()
var classes_attributes = Array()

# 创建一维数组
var player_attributes = []


func _ready():
	# 初始化 origins 的属性
	for _origin in range(len(Origins)):
		var origins_row = []
		for attribute in range(len(Attributes)):
			origins_row.append(0)  # 初始化为 0 或适当的默认值
		origins_attributes.append(origins_row)

	# 初始化 classes 的属性
	for _class in range(len(Classes)):
		var classes_row = []
		for attribute in range(len(Attributes)):
			classes_row.append(0)  # 初始化为 0 或适当的默认值
		classes_attributes.append(classes_row)
		 
	for attribute in range(len(Attributes)):
		player_attributes.append(0)  # 初始化为 0
		


# 函数来设置属性值
func set_origins_attribute(origins: int, attribute: int, value):
	origins_attributes[origins][attribute] += value
	attribute_changed.emit()
	

func set_classes_attribute(classes: int, attribute: int, value):
	classes_attributes[classes][attribute] += value
	attribute_changed.emit()

func set_player_attribute(attribute: int, value):
	player_attributes[attribute] += value
	attribute_changed.emit()
