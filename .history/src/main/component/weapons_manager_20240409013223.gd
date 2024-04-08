extends Node2D

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	print(players.size())
