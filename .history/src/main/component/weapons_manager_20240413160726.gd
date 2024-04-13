extends Node2D


@onready var weapons_instance: Node2D = $WeaponsInstance

@onready var player_1: Node2D = $Player1
@onready var player_2: Node2D = $Player2
@onready var player_3: Node2D = $Player3
@onready var player_4: Node2D = $Player4

var players = []

func _ready():
	players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("register_weapon", self, "_on_player_register_weapon")


func _on_player_register_weapon(player: CharacterBody2D, weaponName: String, weapon_slot: int) -> void:
	var weapon = weapons_instance.instance_weapon(weaponName)
    var slot = player.weapons_track
