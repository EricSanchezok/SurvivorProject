extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvas_modulate: CanvasModulate = $CanvasModulate


func _ready() -> void:
	# Game.pause_screen.connect("show_equipment_screen", _on_show_equipment_screen)
	pass
	
func _on_show_equipment_screen(show: bool) -> void:
	canvas_modulate.color = Game.pause_screen.canvas_modulate.color
	if show and not visible:
		show()
		animation_player.play("show")
	if not show and visible:
		hide()
		animation_player.play("hide")
