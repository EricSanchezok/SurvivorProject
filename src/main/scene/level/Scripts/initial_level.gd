extends Node2D

func _ready() -> void:
	$Fire.play("default")


func _on_audio_stream_player_2d_finished() -> void:
	$Fire/AudioStreamPlayer2D.play()
