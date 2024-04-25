extends Node2D

@onready var weapon_instance: WeaponInstance = $WeaponInstance

signal weapon_manager

var players = []
var players_weapon = {
	Player1_weapon =[],
	Player2_weapon =[],
	Player3_weapon =[],
	Player4_weapon =[],
}

var weapon_origins = []
var weapon_classes = []

func _ready():
	players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("register_weapon", _on_player_register_weapon)
		
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
	var slot = player.get_weapon_slot(slot_index) # 获取武器槽实例
	var instance = weapon_instance.instance_weapon(weaponName) # 实例化武器
	
	# 设置武器实例属性
	instance.slot = slot
	instance.player = player
	instance.player_stats = player.player_stats
	instance.position = slot.global_position
	
	# 添加武器实例到对应的玩家槽(玩家槽在当前节点中)
	var index = players.find(player) + 1
	var playerindex = "Player"+ str(index)
	var player_slot = get_node(playerindex)
	player_slot.add_child(instance)
	players_weapon[playerindex+"_weapon"].append(instance)
	weapon_origins = instance.origins
	weapon_classes = instance.classes
	if players_weapon[playerindex+"_weapon"].find(instance) != -1:
		for origins in weapon_origins:
			player.update_origins_number(origins,1)
		for classes in weapon_classes:
			player.update_classes_number(classes,1)
	



