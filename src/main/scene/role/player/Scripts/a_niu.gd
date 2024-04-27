extends PlayerBase


func _ready() -> void:
	super()
	register_weapon.emit(self, "skyblast_cannon", 1)
