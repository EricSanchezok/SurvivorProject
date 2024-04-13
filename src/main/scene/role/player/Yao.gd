extends Player


func _ready() -> void:
	register_weapon.emit(self, "normal_bow", 1)
	register_weapon.emit(self, "normal_bow", 2)
	register_weapon.emit(self, "normal_bow", 3)
	register_weapon.emit(self, "normal_bow", 4)
	register_weapon.emit(self, "normal_bow", 5)
	register_weapon.emit(self, "normal_bow", 6)
	register_weapon.emit(self, "normal_bow", 7)
	register_weapon.emit(self, "normal_bow", 8)
	register_weapon.emit(self, "normal_bow", 9)
	register_weapon.emit(self, "normal_bow", 10)
	pass
