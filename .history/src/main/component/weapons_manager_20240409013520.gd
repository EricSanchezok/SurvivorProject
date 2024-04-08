extends Node2D

# 创建一个字典，用于存储玩家的信息
var players = {}

func _ready() -> void:
	var array_players = get_tree().get_nodes_in_group("player")
    for player in array_players:
        players[player.get_name()] = player

