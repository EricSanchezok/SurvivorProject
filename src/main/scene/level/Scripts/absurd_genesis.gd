extends Node2D


var players = []
func _ready():
	players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.camera_2d.limit_top = -515
		player.camera_2d.limit_bottom = 225
		player.camera_2d.limit_left = -684
		player.camera_2d.limit_right = 679
		
