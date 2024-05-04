extends Npc



func _ready() -> void:
	super()
	$AnimationPlayer.play("idle")
	$Interactable.sprite_2d = $Sprite2D
