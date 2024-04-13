extends Player


func _ready() -> void:
	register_weapon.emit(self, "normal_dagger", 1)
	register_weapon.emit(self, "normal_dagger", 2)
	register_weapon.emit(self, "normal_dagger", 3)
	register_weapon.emit(self, "normal_dagger", 4)
	register_weapon.emit(self, "normal_dagger", 5)
	register_weapon.emit(self, "normal_dagger", 6)
	register_weapon.emit(self, "normal_dagger", 7)
	register_weapon.emit(self, "normal_dagger", 8)
	register_weapon.emit(self, "normal_dagger", 9)
	register_weapon.emit(self, "normal_dagger", 10)
	pass
