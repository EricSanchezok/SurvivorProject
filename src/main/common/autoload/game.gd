extends CanvasLayer


@onready var pause_screen: Control = $PauseScreen
@onready var pause_animation_player: AnimationPlayer = $PauseScreen/AnimationPlayer

var next_level: bool = false
