extends Node2D


@onready var enemies = {
	"shade": preload("res://src/main/scene/role/enemy/shade.tscn")
}




func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	var station_areas = get_tree().get_first_node_in_group("station_area")

	WeaponsManager.level_initialization(self, players, station_areas)


	
	$EnemyGenerator.register_enemy(enemies["shade"], 20)
