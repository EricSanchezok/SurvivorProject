extends Npc

func _ready() -> void:
	super()
	$AnimationPlayer.play("idle")
	$Interactable.sprite_2d = $Sprite2D
	
	$Interactable.interacted.connect(_on_interact)


func _on_interact(player: PlayerBase) -> void:
	Global.show_online_mode_screen()

