extends Node2D

func _ready() -> void:
    # 获取根节点下所有player组的节点
    var players = get_tree().get_nodes_in_group("player")
    print(players.size())