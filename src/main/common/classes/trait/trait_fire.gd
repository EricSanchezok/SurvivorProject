class_name  trait_fire
extends Node

var players = []

func _ready():
	players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.fire.connect("fire_trait", _on_player_fire_trait)
		

func _on_player_fire_trait(fire_number: int ) -> void:
	if fire_number >= 9:
		owner.attribute_calculator.trait_magic_attack_power = owner.base_magic_attack_power * 3
	elif fire_number >= 7:
		owner.attribute_calculator.trait_magic_attack_power = owner.base_magic_attack_power * 2
	elif fire_number >= 5:
		owner.attribute_calculator.trait_magic_attack_power = owner.base_magic_attack_power * 1.5
	elif fire_number >= 3:
		owner.attribute_calculator.trait_magic_attack_power = owner.base_magic_attack_power * 1.2
	
