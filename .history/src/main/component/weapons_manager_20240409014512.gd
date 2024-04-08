extends Node2D


@onready var weapons_instance: WeaponsInstance = $WeaponsInstance

var players = []

func _ready() -> void:
	players = get_tree().get_nodes_in_group("player")


