extends PlayerBase


func _ready() -> void:
	super()
	register_weapon.emit(self, "storm_axe", 1)
	#register_weapon.emit(self, "skyblast_cannon", 1)
	#register_weapon.emit(self, "frost_shield", 5)
	#register_weapon.emit(self, "fire_guardian", 6)
