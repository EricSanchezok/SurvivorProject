class_name Attribute_Changed
extends Node

signal attribute_changed

# 定义origins和classes
enum Origins {FIRE, FROST, LIGHTING, EARTH, TOXIN, NATURE, DIVINITY, DEMON}

enum Classes {SWORD, SHIELD, AXE, SPEAR, DAGGER, BOW, STAFF, SCROLL, FIREARM, STATION, BOOK}


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

func enum_to_string(enum_value, enum_type = null):
	if enum_type == null:
		return "Invalid enum type"

	if enum_type == Origins:
		match enum_value:
			Origins.FIRE: return "FIRE"
			Origins.FROST: return "FROST"
			Origins.LIGHTING: return "LIGHTING"
			Origins.EARTH: return "EARTH"
			Origins.TOXIN: return "TOXIN"
			Origins.NATURE: return "NATURE"
			Origins.DIVINITY: return "DIVINITY"
			Origins.DEMON: return "DEMON"
			_:
				return "Unknown enum value"

	if enum_type == Classes:
		match enum_value:
			Classes.SWORD: return "SWORD"
			Classes.SHIELD: return "SHIELD"
			Classes.AXE: return "AXE"
			Classes.SPEAR: return "SPEAR"
			Classes.DAGGER: return "DAGGER"
			Classes.BOW: return "BOW"
			Classes.STAFF: return "STAFF"
			Classes.SCROLL: return "SCROLL"
			Classes.FIREARM: return "FIREARM"
			Classes.STATION: return "STATION"
			Classes.BOOK: return "BOOK"
			_:
				return "Unknown enum value"

func string_to_enum(string_value, enum_type = null):
	if enum_type == null:
		return "Invalid enum type"

	if enum_type == Origins:
		match string_value:
			"FIRE": return Origins.FIRE
			"FROST": return Origins.FROST
			"LIGHTING": return Origins.LIGHTING
			"EARTH": return Origins.EARTH
			"TOXIN": return Origins.TOXIN
			"NATURE": return Origins.NATURE
			"DIVINITY": return Origins.DIVINITY
			"DEMON": return Origins.DEMON
			_:
				return "Unknown enum value"

	if enum_type == Classes:
		match string_value:
			"SWORD": return Classes.SWORD
			"SHIELD": return Classes.SHIELD
			"AXE": return Classes.AXE
			"SPEAR": return Classes.SPEAR
			"DAGGER": return Classes.DAGGER
			"BOW": return Classes.BOW
			"STAFF": return Classes.STAFF
			"SCROLL": return Classes.SCROLL
			"FIREARM": return Classes.FIREARM
			"STATION": return Classes.STATION
			"BOOK": return Classes.BOOK
			_:
				return "Unknown enum value"
