extends Node

@onready var pause_screen: Control = $CanvasLayer/PauseScreen

var players = []
func _ready():
	players = get_tree().get_nodes_in_group("player")
	for player in players:
		print(player)
