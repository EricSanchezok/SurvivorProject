extends Node2D

@onready var weapon_instance: WeaponInstance = $WeaponInstance

#signal weapon_manager

@onready var players: Array = get_tree().get_nodes_in_group("player")
var players_weapons_all = {}
var players_weapons_equipped = {}
@onready var turret_areas: PositionGenerator = get_tree().get_first_node_in_group("TurretAreas")


func _ready():
	for player in players:
		player.connect("register_weapon", _on_player_register_weapon)
		players_weapons_equipped[player] = [] # 初始化玩家武器字典
		
		
func player_index(player: CharacterBody2D) -> int:
	var index = players.find(player) + 1
	return index


func _on_player_register_weapon(player: CharacterBody2D, weaponName: String, slot_index: int) -> void:
	'''
	注册武器
	
	:param player: 玩家
	:param weaponName: 武器名
	:param weapon_slot: 武器槽
	'''
	# print("player:", player, "weapon_name:", weaponName, "weapon_slot:", weapon_slot)
	var slot = player.get_weapon_slot(slot_index) # 获取在玩家节点下的武器槽实例
	var instance = weapon_instance.instance_weapon(weaponName) # 实例化武器
	
	# 设置武器实例属性
	instance.slot = slot
	instance.player = player
	instance.player_stats = player.player_stats
	
	var weapon_stats = instance.get_node("WeaponStats") # 这时候weapon还未ready，所以需要get_node来获取
	if weapon_stats.classes.has(Attribute_Changed.Classes.TURRET):
		instance.position = turret_areas.get_random_position()
	else:
		instance.position = slot.global_position
	
	if instance not in players_weapons_equipped[player]:
		for _origin in weapon_stats.origins:
			player.update_origins_number(_origin,1)
		for _class in weapon_stats.classes:
			player.update_classes_number(_class,1)	
	
	players_weapons_equipped[player].append(instance)
	add_child(instance)
	






