extends Node2D

@onready var player_1: Node2D = $Player1
@onready var player_2: Node2D = $Player2
@onready var player_3: Node2D = $Player3
@onready var player_4: Node2D = $Player4

var players = []

func _ready():
	players = get_tree().get_nodes_in_group("player")

    
