extends Node2D

@onready var weapons_instance: Node2D = $WeaponsInstance

var players = []
func _ready():
	players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("register_weapon", _on_player_register_weapon)


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
	weapon_instance.position = slot_instance.global_position
	
	# 添加武器实例到对应的玩家槽(玩家槽在当前节点中)
	var index = players.find(player) + 1
	var player_slot = get_node("Player" + str(index))
	player_slot.add_child(weapon_instance)



	
