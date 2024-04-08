extends Node2D



var players = []

func _ready() -> void:
	players = get_tree().get_nodes_in_group("player")

