extends Node2D


@onready var weapons_instance: Node2D = $WeaponsInstance


var players = []

func _ready():
	players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("register_weapon", _on_player_register_weapon)


func _on_player_register_weapon(player: CharacterBody2D, weaponName: String, weapon_slot: int) -> void:
	var slot_instance = player.weapons_track.get_weapon_slot_instance(weapon_slot)
	var weapon_instance = weapons_instance.instance_weapon(weaponName)
	weapon_instance.slot = slot_instance
	
	var index = players.find(player) + 1
	var player_slot = get_node("Player" + str(index))
	player_slot.add_child(weapon_instance)



	
