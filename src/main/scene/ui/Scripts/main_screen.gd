extends Control


@export_file("*.tscn") var path: String
@export var entry_point: String


func _on_start_game_pressed() -> void:
	Global.change_scene(path)
