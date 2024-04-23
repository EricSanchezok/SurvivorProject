extends Node2D

@onready var weapons_instance: Node2D = $WeaponsInstance

var players = []
var players_weapon ={
	Player1_weapon = [],
	Player2_weapon = [],
	Player3_weapon = [],
	Player4_weapon = [],
}



func _ready():
	players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("register_weapon", _on_player_register_weapon)
		
func player_index(player: CharacterBody2D) -> int:
	var index = players.find(player) + 1
	return index


func _on_player_register_weapon(player: CharacterBody2D, weaponName: String, weapon_slot: int) -> void:
	'''
	注册武器
	
	:param player: 玩家
	:param weaponName: 武器名
	:param weapon_slot: 武器槽
	'''
	# print("player:", player, "weapon_name:", weaponName, "weapon_slot:", weapon_slot)
	var slot_instance = player.weapons_track.get_weapon_slot_instance(weapon_slot) # 获取武器槽实例
	var weapon_instance = weapons_instance.instance_weapon(weaponName) # 实例化武器
	
	# 设置武器实例属性
	weapon_instance.slot = slot_instance
	weapon_instance.player = player
	weapon_instance.playerStats = player.playerStats
	#weapon_instance.attribute_calculator.playerStats = player.playerStats
	weapon_instance.position = slot_instance.global_position
	
	# 添加武器实例到对应的玩家槽(玩家槽在当前节点中)
	var index = players.find(player) + 1
	var playerindex = "Player" + str(index)
	var player_slot = get_node(playerindex)
	
	
	player_slot.add_child(weapon_instance)
	players_weapon[playerindex+"_weapon"].append(weapon_instance)
	#print(players_weapon[playerindex+"_weapon"][0].physical_attack_power)
	#players_weapon[playerindex+"_weapon"][0].modify_attribute("physical_attack_power","percent",0.5)
	#print(players_weapon[playerindex+"_weapon"][0].physical_attack_power)
	
	player.fire.fire_number = 5
	



	
