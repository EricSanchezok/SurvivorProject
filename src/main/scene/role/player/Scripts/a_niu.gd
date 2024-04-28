extends PlayerBase


func _ready() -> void:
	super()
	register_weapon.emit(self, "surtr's_fury", 1)
	#register_weapon.emit(self, "skyblast_cannon", 1)
	register_weapon.emit(self, "frost_shield", 5)
