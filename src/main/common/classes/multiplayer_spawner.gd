class_name Spawner
extends MultiplayerSpawner


@export var playerScene: PackedScene
@export var spawn_marker_2d: Marker2D

var players = {}

func _ready() -> void:
	await owner.ready
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)

func spawnPlayer(data) -> PlayerBase:
	print("Spawning player: ", data)
	var p = playerScene.instantiate()
	p.position = spawn_marker_2d.global_position
	p.set_multiplayer_authority(data)
	players[data] = p
	return p

func removePlayer(data):
	players[data].queue_free()
	players.erase(data)
